// End-to-end check of the release web build in a real browser.
//
//   tool/build_web.sh
//   node test_e2e/browser_test.js
//
// Serves build/web, drives every feature through Flutter's accessibility
// tree, and saves a screenshot of each step to test_e2e/output/.
// Phone calls, texts and links are captured instead of opened, location is
// faked (Cape Town) and the hospital search API is answered with fixture data.

const http = require('http');
const fs = require('fs');
const path = require('path');
const assert = require('assert');
const { chromium } = require('playwright');

const root = path.join(__dirname, '..', 'build', 'web');
const out = path.join(__dirname, 'output');
fs.mkdirSync(out, { recursive: true });

const types = {
  '.html': 'text/html', '.js': 'text/javascript', '.mjs': 'text/javascript',
  '.json': 'application/json', '.wasm': 'application/wasm', '.png': 'image/png',
  '.ttf': 'font/ttf', '.otf': 'font/otf', '.css': 'text/css', '.bin': 'application/octet-stream',
};

function serve() {
  const server = http.createServer((req, res) => {
    let file = path.join(root, decodeURIComponent(req.url.split('?')[0]));
    if (file.endsWith('/')) file += 'index.html';
    fs.readFile(file, (err, data) => {
      if (err) { res.writeHead(404); return res.end(); }
      res.writeHead(200, { 'Content-Type': types[path.extname(file)] || 'application/octet-stream' });
      res.end(data);
    });
  });
  return new Promise((r) => server.listen(0, () => r(server)));
}

const hospitalsFixture = {
  elements: [
    {
      type: 'way', center: { lat: -33.9411, lon: 18.4654 },
      tags: { name: 'Groote Schuur Hospital', amenity: 'hospital', phone: '+27 21 404 9111',
        'addr:street': 'Main Road', 'addr:suburb': 'Observatory' },
    },
    { type: 'node', lat: -33.9205, lon: 18.4180, tags: { name: 'Cape Town Mediclinic', amenity: 'hospital' } },
    { type: 'node', lat: -33.9301, lon: 18.4120, tags: { name: 'Gardens Community Clinic', amenity: 'clinic' } },
  ],
};

let step = 0;
let page;
const results = [];

async function settle(ms = 700) { await page.waitForTimeout(ms); }

async function shot(name) {
  step += 1;
  await page.screenshot({ path: path.join(out, `${String(step).padStart(2, '0')}-${name}.png`) });
}

async function check(name, fn) {
  try {
    await fn();
    results.push(['PASS', name]);
    console.log(`  ✓ ${name}`);
  } catch (e) {
    results.push(['FAIL', name, e.message.split('\n')[0]]);
    console.log(`  ✗ ${name}\n      ${e.message.split('\n').slice(0, 3).join('\n      ')}`);
    await shot(`FAILED-${name.replace(/\W+/g, '-')}`);
    if (process.env.DEBUG) console.log(await page.locator('body').ariaSnapshot());
  }
}

// Flutter exposes widgets to the browser's accessibility tree, mostly as
// aria-labels; find things by their accessible name.
function labelled(text) {
  return page.locator(`[aria-label*=${JSON.stringify(text)}]`);
}

function byText(text) {
  return page.getByRole('button', { name: text, exact: false })
    .or(labelled(text))
    .or(page.getByText(text, { exact: false }));
}

// Flutter leaves off-screen widgets out of the accessibility tree, so scroll
// the page's semantic scroll view (Flutter mirrors it) until one appears.
async function reveal(locator) {
  for (let i = 0; i < 12 && !(await locator.count()); i++) {
    await page.evaluate((down) => {
      const views = [...document.querySelectorAll('flt-semantics')]
        .filter((e) => getComputedStyle(e).overflowY === 'scroll');
      const v = views.at(-1);
      if (v) v.scrollTop += down ? 400 : -400;
    }, i < 6);
    await settle(400);
  }
}

async function tap(text) {
  await reveal(byText(text));
  const button = page.getByRole('button', { name: text, exact: false });
  const target = (await button.count()) ? button.first() : byText(text).last();
  await tapLocator(target);
}

// Semantics nodes don't take pointer events: bring the node on screen, then
// click the Flutter canvas at its centre, just like a finger would.
async function tapLocator(target) {
  await target.scrollIntoViewIfNeeded().catch(() => {});
  await settle(400);
  const box = await target.boundingBox();
  await page.mouse.click(box.x + box.width / 2, box.y + box.height / 2);
  await settle();
}

async function topOf(text) {
  return (await byText(text).first().boundingBox()).y;
}

async function fill(label, value) {
  const box = page.getByRole('textbox', { name: label }).first();
  await tapLocator(box);
  await settle(150);
  // Flutter routes typing through a hidden <input> that gets focus.
  const input = page.locator('input:focus, textarea:focus');
  // In accessibility mode the textbox node is itself an <input>; if the tap
  // didn't leave a focused input, type into that node directly.
  await (await input.count() ? input : box).fill(value);
  await settle(150);
}

async function see(text) {
  await reveal(byText(text));
  await byText(text).first().waitFor({ state: 'attached', timeout: 5000 });
}

async function back() {
  await tapLocator(page.getByRole('button', { name: 'Back' }).first());
  await settle();
}

async function opened() { return page.evaluate(() => window.__opened); }

(async () => {
  const server = await serve();
  const url = `http://localhost:${server.address().port}/`;
  const browser = await chromium.launch();
  const context = await browser.newContext({
    viewport: { width: 412, height: 915 },
    deviceScaleFactor: 2,
    geolocation: { latitude: -33.9249, longitude: 18.4241 },
    permissions: ['geolocation'],
  });
  await context.addInitScript(() => {
    window.__opened = [];
    window.open = (u) => { window.__opened.push(String(u)); return null; };
  });
  await context.route('https://overpass-api.de/**', (route) =>
    route.fulfill({ status: 200, contentType: 'application/json', body: JSON.stringify(hospitalsFixture) }));

  page = await context.newPage();
  const errors = [];
  page.on('pageerror', (e) => errors.push(e.message));
  page.on('console', (m) => { if (m.type() === 'error') errors.push(m.text()); });

  async function load() {
    await page.goto(url);
    await page.waitForSelector('flt-semantics-placeholder', { state: 'attached', timeout: 60000 });
    await page.evaluate(() => document.querySelector('flt-semantics-placeholder').click());
    await settle(1200);
  }
  await load();

  console.log('Elderly Care browser test');

  await check('onboarding shows five intro pages', async () => {
    await see('Never miss a medicine');
    await shot('onboarding');
    for (const title of ['Remember appointments', 'Track your health', 'Find help nearby', 'Family is one tap away']) {
      await tap('Next');
      await see(title);
    }
    await tap('Get started');
  });

  await check('setup validates and creates the profile', async () => {
    await see('Welcome to Elderly Care');
    await tap('Continue');
    await see('Please enter your name');
    await fill('Your name', 'Margaret Smith');
    await fill('Their name', 'Anna Smith');
    await fill('Relationship', 'Daughter');
    await fill('Their phone number', '082 555 0101');
    await shot('setup');
    await tap('Continue');
    await see('Margaret');
    await see('I need help');
    await shot('home');
  });

  await check('medicine reminder: add, schedule, confirm a dose', async () => {
    await tap('Medicines');
    await see('No medicines yet');
    await tap('Add medicine');
    await fill('Medicine name', 'Metformin');
    await fill('How much (optional)', '500 mg');
    await tap('Twice');
    await shot('medicine-add');
    await tap('Save reminder');
    await see("Today's schedule");
    await see('2× a day');
    await shot('medicines');
    await page.getByRole('button', { name: /Metformin.*8:00/ }).first().click({ force: true });
    await settle();
    await see('Did you take your Metformin?');
    await shot('dose-check');
    await tap('Yes, I took it');
    await see('Taken');
    await back();
  });

  await check('appointment: add and see it on home', async () => {
    await tap('Appointments');
    await tap('Add appointment');
    await fill("Doctor's name", 'Dr. Naidoo');
    await fill('Type of doctor (optional)', 'Cardiologist');
    await fill('Where (optional)', 'Groote Schuur Hospital');
    await tap('Save appointment');
    await see('Upcoming (1)');
    await see('Cardiologist');
    await shot('appointments');
    await back();
    await see('Dr. Naidoo');
  });

  await check('health tracker: record two blood pressure readings and chart them', async () => {
    await tap('Health tracker');
    await shot('health');
    await tap('Blood pressure');
    for (const [s, d, p] of [['132', '86', '74'], ['124', '80', '70']]) {
      await tap('Add reading');
      await fill('Systolic (top number)', s);
      await fill('Diastolic (bottom number)', d);
      await fill('Pulse', p);
      await tap('Save reading');
    }
    await see('124/80 mmHg');
    await see('Blood pressure chart of the last 2 readings');
    await shot('blood-pressure');
    await back();
    await back();
  });

  await check('family: add a person, call and text them', async () => {
    await tap('My family');
    await tap('Add person');
    await fill('Name', 'Ben Smith');
    await fill('Relationship (optional)', 'Son');
    await fill('Phone number', '083 555 0202');
    await tap('Save');
    await see('Son · 083 555 0202');
    await shot('family');
    await tapLocator(page.getByRole('button', { name: 'Call', exact: true }).nth(1));
    await tapLocator(page.getByRole('button', { name: 'Text', exact: true }).nth(1));
    await settle();
    const o = await opened();
    assert.deepStrictEqual(o.slice(-2), ['tel:0835550202', 'sms:0835550202?body=']);
    await back();
  });

  await check('SOS: emergency call and family alert with location', async () => {
    if (process.env.DEBUG) {
      console.log(await page.locator('body').ariaSnapshot());
      console.log(await page.getByRole('button', { name: 'I need help' }).first().boundingBox());
    }
    await tap('I need help');
    await see('How can we help?');
    await shot('sos');
    await tap('Call emergency services');
    await tap('I need help');
    await tap('Alert my family');
    await page.waitForFunction(() => window.__opened.some((u) => u.includes('needs%20help')), null, { timeout: 15000 });
    const o = await opened();
    assert(o.includes('tel:112'), 'dialled 112');
    const sms = o.find((u) => u.includes('needs%20help'));
    assert(sms.startsWith('sms:0825550101,0835550202?body='), sms);
    assert(decodeURIComponent(sms).includes('query=-33.924900,18.424100'), 'includes location');
  });

  await check('hospitals: lists nearby places nearest first with directions', async () => {
    await tap('Hospitals nearby');
    await see('3 places within 10 km');
    await see('Groote Schuur Hospital');
    await shot('hospitals');
    assert(await topOf('Cape Town Mediclinic') < await topOf('Groote Schuur Hospital'), 'sorted by distance');
    await tapLocator(page.getByRole('button', { name: 'Directions' }).first());
    await settle();
    assert((await opened()).at(-1).startsWith('https://www.google.com/maps/dir/?api=1&destination='));
    await back();
  });

  await check('video call: opens a Jitsi room and texts family the link', async () => {
    await tap('Video call');
    await shot('video-call');
    await tap('Start video call');
    const o = await opened();
    const call = o.at(-1);
    assert(/^https:\/\/meet\.jit\.si\/ElderlyCare-[a-z0-9]{16}#/.test(call), call);
    assert(!call.split('#')[0].includes('margaret'), 'no name in the room address');
    assert(o.at(-2).includes(encodeURIComponent(call.split('#')[0])), 'family texted the room link');
    await back();
  });

  await check('notes: important notes sort first', async () => {
    await tap('Notes');
    await tap('New note');
    await fill('Title', 'Buy milk');
    await tap('Save note');
    await tap('New note');
    await fill('Title', 'Ask Dr. Naidoo about my knee');
    await fill('Note', 'Pain when climbing stairs in the morning');
    await tap('Important');
    await tap('Save note');
    assert(await topOf('Ask Dr. Naidoo') < await topOf('Buy milk'), 'important note first');
    await shot('notes');
    await back();
  });

  await check('documents: upload a photo, name it, search and open it', async () => {
    await tap('Documents');
    await tap('Add document');
    const chooser = page.waitForEvent('filechooser');
    await tap('Choose from gallery');
    await (await chooser).setFiles(path.join(__dirname, 'fixtures', 'prescription.png'));
    await see('Save document');
    await fill('Name', 'Prescription March');
    await tap('Save document');
    await see('Prescription March');
    await shot('documents');
    await fill('Search documents', 'xyz');
    await see('Nothing matches');
    await fill('Search documents', 'presc');
    await tap('Prescription March');
    await settle();
    await shot('document-view');
    await back();
    await back();
  });

  await check('profile: edit medical details', async () => {
    await tapLocator(page.getByRole('button', { name: 'My profile' }));
    await settle();
    await tap('Edit');
    await fill('Blood group', 'O+');
    await fill('Allergies', 'Penicillin');
    await fill('Medical conditions', 'Type 2 diabetes');
    await tap('Save profile');
    await see('Penicillin');
    await shot('profile');
  });

  await check('backup: downloads a backup file of all data', async () => {
    const download = page.waitForEvent('download', { timeout: 15000 });
    await tap('Back up my data');
    await see('Protect your backup?');
    await tap('No password');
    const file = await download;
    assert(/^elderly-care-backup-\d{4}-\d\d-\d\d\.json$/.test(file.suggestedFilename()), file.suggestedFilename());
    const backup = JSON.parse(fs.readFileSync(await file.path(), 'utf8'));
    assert.strictEqual(backup.format, 'elderly-care-backup');
    assert(JSON.stringify(backup.data).includes('Metformin'), 'contains medicines');
    fs.copyFileSync(await file.path(), path.join(out, 'backup.json'));
    await see('Backup ready');
  });

  await check('text size: Extra large enlarges the app', async () => {
    await tap('Extra large');
    await back();
    await settle(600);
    await shot('home-extra-large-text');
    await tapLocator(page.getByRole('button', { name: 'My profile' }));
    await tap('Normal');
    await back();
  });

  await check('medical ID: opens from SOS with key facts', async () => {
    await tap('I need help');
    await tap('Show my medical ID');
    for (const t of ['Medical ID', 'O+', 'Penicillin', 'Type 2 diabetes', 'Metformin 500 mg']) await see(t);
    await shot('medical-id');
    await back();
  });

  await check('health tracker: share opens a summary for the doctor', async () => {
    await tap('Health tracker');
    await tap('Share');
    await settle(800);
    const o = await opened();
    const mail = o.find((u) => u.startsWith('mailto:'));
    assert(mail, `expected a share fallback, got ${o.slice(-2)}`);
    const body = decodeURIComponent(mail);
    assert(body.includes('Health summary for Margaret Smith'), body.slice(0, 200));
    assert(body.includes('124/80 mmHg'), 'includes readings');
    await back();
  });

  await check('everything is still there after reloading the page', async () => {
    await load();
    await see('Good');
    await see('Dr. Naidoo');
    await tap('Medicines');
    await see('Metformin');
    await back();
    await tap('Documents');
    await see('Prescription March');
    await back();
  });

  await check('security: no readable health data in browser storage', async () => {
    const stored = await page.evaluate(() => JSON.stringify({ ...localStorage }));
    for (const secret of ['Penicillin', 'Metformin', 'Dr. Naidoo', 'Anna Smith', '124/80', 'Prescription March']) {
      assert(!stored.includes(secret), `"${secret}" is readable in localStorage`);
    }
    assert(stored.includes('enc1:'), 'data is stored encrypted');
    const csp = await page.evaluate(() =>
      document.querySelector('meta[http-equiv="Content-Security-Policy"]')?.content ?? '');
    assert(csp.includes("script-src 'self'"), 'release build has a Content-Security-Policy');
  });

  await check('security: privacy page confirms encryption', async () => {
    await tapLocator(page.getByRole('button', { name: 'My profile' }));
    await tap('Privacy & security');
    await see('Encrypted on this device');
    await see('App lock is off');
    await shot('privacy-security');
  });

  await check('security: app lock with a PIN, also after reloading', async () => {
    await tap('Lock with a PIN');
    await fill('New PIN', '2580');
    await fill('Type it again', '2580');
    await tap('Save');
    await see('App lock is on');
    await tap('Lock now');
    await see('Enter your PIN');
    await shot('lock-screen');
    // Wrong PIN, typed on the keyboard.
    await page.keyboard.type('1111');
    await page.keyboard.press('Enter');
    await see('That PIN is not right');
    // The emergency panel works while locked.
    await tap('Emergency');
    await see('Call 112');
    await see('Penicillin');
    await shot('lock-emergency');
    await back();
    // Reload: the app must start locked.
    await load();
    await see('Enter your PIN');
    assert(!(await byText('Dr. Naidoo').count()), 'nothing visible while locked');
    for (const d of '2580') await tapLocator(page.getByRole('button', { name: d, exact: true }));
    await tapLocator(page.getByRole('button', { name: 'Unlock' }));
    await see('Dr. Naidoo');
  });

  await check('dark mode renders', async () => {
    await page.emulateMedia({ colorScheme: 'dark' });
    await settle(800);
    await shot('home-dark');
    await page.emulateMedia({ colorScheme: 'light' });
  });

  await check('tablet / desktop width keeps content readable', async () => {
    await page.setViewportSize({ width: 1280, height: 860 });
    await settle(800);
    await shot('home-wide');
    await page.setViewportSize({ width: 412, height: 915 });
  });

  await check('no errors in the browser console', async () => {
    assert.deepStrictEqual(errors, []);
  });

  await browser.close();
  server.close();
  const failed = results.filter((r) => r[0] === 'FAIL');
  console.log(`\n${results.length - failed.length}/${results.length} checks passed. Screenshots: ${out}`);
  process.exit(failed.length ? 1 : 0);
})();
