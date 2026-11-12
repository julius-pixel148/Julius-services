/* Shared by every page. Edit your business details here once; all pages update. */
/* ===== EDIT YOUR DETAILS HERE ===== */
var CONFIG = {
  phone: "(425) 699-9636",         // e.g. "(425) 555-0100"
  email: "ask@juliusremodeling.com",         // e.g. "hello@juliusservices.com"
  license: "JULIURG780NJ",       // your WA contractor license number
  insurance: "Licensed, insured & bonded",     // e.g. "Licensed, insured & bonded" (only what is true for this business)
  hours: "Mon–Fri 9am–5pm · Sun 10am–3pm",         // e.g. "Mon–Sat 8am–6pm"
  address: "800 Bellevue Way NE, Suite 500, Bellevue, WA 98004",       // office address, or the area you work from, e.g. "Bellevue, WA"
  formEndpoint: ""   // booking form: paste a Formspree (or similar) URL here. See README.
};
/* ================================== */
(function(){
  // Fill details. Anything left blank above stays visible as a dashed [placeholder].
  document.querySelectorAll('[data-k]').forEach(function(el){
    var v = CONFIG[el.getAttribute('data-k')];
    if (v) el.textContent = v; else el.classList.add('ph-mark');
  });
  if (CONFIG.email) document.querySelectorAll('[data-mail]').forEach(function(a){ a.href = 'mailto:' + CONFIG.email; });
  if (CONFIG.phone) {
    var digits = CONFIG.phone.replace(/[^\d+]/g, '');
    document.querySelectorAll('[data-tel]').forEach(function(a){ a.href = 'tel:' + digits; });
  }

  // Header turns solid after the hero headline
  var hdr = document.getElementById('hdr');
  if (hdr) {
    var onScroll = function(){ if (!hdr.hasAttribute('data-solid')) hdr.classList.toggle('solid', window.scrollY > 40); };
    onScroll(); window.addEventListener('scroll', onScroll, {passive:true});
  }

  // "Copy" buttons next to phone / email
  document.querySelectorAll('[data-copy]').forEach(function(b){
    b.addEventListener('click', function(){
      var v = CONFIG[b.getAttribute('data-copy')], t = b.textContent;
      if (!v) return;
      var ok = function(){ b.textContent = 'Copied'; setTimeout(function(){ b.textContent = t; }, 1600); };
      try { navigator.clipboard.writeText(v).then(ok, function(){}); } catch(e){}
    });
  });

  // Business details for search engines, built from CONFIG so there is one place to edit
  try {
    var ld = { '@context':'https://schema.org', '@type':'HomeAndConstructionBusiness', name:'Julius Services',
      description:'Chimney sweeping, inspections, and repairs, plus gutter cleaning, roof moss removal, dryer vent cleaning, and pressure washing.',
      url: location.origin + '/', image: location.origin + '/assets/logo.jpg',
      areaServed: ['Seattle','Bellevue','Mercer Island','Kirkland','Redmond','Sammamish','Issaquah','Bothell','Renton','Shoreline'] };
    if (CONFIG.phone) ld.telephone = CONFIG.phone;
    if (CONFIG.email) ld.email = CONFIG.email;
    if (CONFIG.address) ld.address = CONFIG.address;
    var s = document.createElement('script'); s.type = 'application/ld+json'; s.textContent = JSON.stringify(ld);
    document.head.appendChild(s);
  } catch(e){}

  // Booking form (book.html)
  var form = document.getElementById('book-form');
  if (form) {
    var err = form.querySelector('.err'), fields = form.querySelector('.fields'), done = form.querySelector('.done');
    var pick = new URLSearchParams(location.search).get('service');
    if (pick) form.querySelectorAll('input[name="services"]').forEach(function(c){ if (c.value === pick) c.checked = true; });
    var summary = function(){
      var d = new FormData(form), lines = [];
      lines.push('Name: ' + (d.get('name') || ''));
      lines.push('Phone: ' + (d.get('phone') || ''));
      if (d.get('email')) lines.push('Email: ' + d.get('email'));
      lines.push('Address: ' + (d.get('address') || ''));
      lines.push('Services: ' + (d.getAll('services').join(', ') || 'Not sure yet'));
      if (d.get('message')) lines.push('Details: ' + d.get('message'));
      return lines.join('\n');
    };
    var finish = function(title, text, showCopy){
      fields.hidden = true; done.hidden = false;
      done.querySelector('h3').textContent = title;
      done.querySelector('p').textContent = text;
      done.querySelector('pre').textContent = summary();
      done.querySelector('.copy').hidden = !showCopy;
    };
    done.querySelector('.copy').addEventListener('click', function(){
      var b = this; try { navigator.clipboard.writeText(summary()).then(function(){ b.textContent = 'Copied'; }); } catch(e){}
    });
    form.addEventListener('submit', function(ev){
      ev.preventDefault(); err.textContent = '';
      if (!form.name.value.trim() || !form.phone.value.trim()) { err.textContent = 'Please add your name and a phone number.'; return; }
      if (CONFIG.formEndpoint) {
        var btn = form.querySelector('button[type="submit"]'); btn.disabled = true;
        fetch(CONFIG.formEndpoint, { method:'POST', headers:{ 'Accept':'application/json' }, body:new FormData(form) })
          .then(function(r){ if (!r.ok) throw new Error(); finish('Request sent.', 'Thank you. We will be in touch to confirm a time.', false); })
          .catch(function(){ btn.disabled = false; err.textContent = 'That did not go through. Please try again, or call us.'; });
      } else if (CONFIG.email) {
        location.href = 'mailto:' + CONFIG.email + '?subject=' + encodeURIComponent('Service request from ' + form.name.value.trim()) + '&body=' + encodeURIComponent(summary());
        finish('Almost done.', 'Your email app should have opened with this request ready to send. If it did not, copy the details below and email or text them to us.', true);
      } else {
        finish('Your request is ready.', 'Online booking is not connected yet. Please call us, or copy the details below and send them to us.', true);
      }
    });
  }
})();
