# Builds every page of the Julius Services site: home, service pages, city pages,
# service-areas.html, book.html, 404.html, robots.txt (and sitemap.xml once SITE_URL is set).
#
#   ruby tools/build-pages.rb .
#
# To change wording, edit the text below and run the command again.
# Phone, email, license, hours, and address are NOT here: they live in site.js.
ROOT = ARGV[0] || "."

# Your web address, once you have one, e.g. "https://juliusservices.com" (no slash at the end).
# Leave blank until then; the sitemap is only written when this is filled in.
SITE_URL = ""

BRAND = "Julius Services"
REGION = "Seattle &amp; the Eastside"

# ---------------------------------------------------------------- navigation
CHIMNEY = [
  { slug: "chimney-sweep",        name: "Chimney sweeping",          chip: "Chimney sweeping" },
  { slug: "chimney-inspection",   name: "Chimney inspections",       chip: "Chimney inspection" },
  { slug: "chimney-repair",       name: "Chimney repair",            chip: "Chimney repair" },
  { slug: "chimney-caps-liners",  name: "Caps, dampers &amp; liners", chip: "Caps, dampers and liners" },
  { slug: "fireplace-services",   name: "Fireplaces &amp; stoves",   chip: "Fireplace or stove service" },
]
HOME_CARE = [
  { slug: "gutter-cleaning",            name: "Gutter cleaning",            chip: "Gutter cleaning" },
  { slug: "roof-cleaning-moss-removal", name: "Roof cleaning &amp; moss removal", chip: "Roof cleaning and moss removal" },
  { slug: "dryer-vent-cleaning",        name: "Dryer vent cleaning",        chip: "Dryer vent cleaning" },
  { slug: "air-duct-cleaning",          name: "Air duct cleaning",          chip: "Air duct cleaning" },
  { slug: "pressure-washing",           name: "Pressure washing",           chip: "Pressure washing" },
]
ALL = CHIMNEY + HOME_CARE
# City pages. Add or remove a city here and in CITY_PAGES (further down), then rebuild.
AREAS = [
  { slug: "chimney-services-seattle-wa",       name: "Seattle" },
  { slug: "chimney-services-bellevue-wa",      name: "Bellevue" },
  { slug: "chimney-services-mercer-island-wa", name: "Mercer Island" },
  { slug: "chimney-services-kirkland-wa",      name: "Kirkland" },
  { slug: "chimney-services-redmond-wa",       name: "Redmond" },
  { slug: "chimney-services-sammamish-wa",     name: "Sammamish" },
  { slug: "chimney-services-issaquah-wa",      name: "Issaquah" },
  { slug: "chimney-services-bothell-wa",       name: "Bothell" },
  { slug: "chimney-services-renton-wa",        name: "Renton" },
  { slug: "chimney-services-shoreline-wa",     name: "Shoreline" },
]

def book_url(svc = nil)
  svc ? "book.html?service=#{svc[:chip].gsub(' ', '%20').gsub(',', '%2C')}" : "book.html"
end

def links(list, current)
  list.map { |s| %(<a href="#{s[:slug]}.html"#{s[:slug] == current ? ' aria-current="page"' : ''}>#{s[:name]}</a>) }.join
end

def header(current, home: false)
  p = home ? "" : "index.html"
  svc_cur = ALL.any? { |s| s[:slug] == current } ? ' aria-current="page"' : ""
  area_cur = (current == "service-areas" || AREAS.any? { |s| s[:slug] == current }) ? ' aria-current="page"' : ""
  cta = current == "book" ?
    %(<a href="tel:" data-tel class="btn btn-brass">Call <span data-k="phone">[Phone]</span></a>) :
    %(<a href="book.html" class="btn btn-brass">Book a service <span class="ar" aria-hidden="true">→</span></a>)
  <<~HTML.chomp
    <header class="top#{current == 'book' ? ' solid" data-solid="' : ''}" id="hdr">
      <div class="wrap">
        <a href="#{home ? '#top' : 'index.html'}" class="logo" aria-label="#{BRAND}, home"><img src="assets/wordmark.png" width="300" height="206" alt="#{BRAND}"></a>
        <nav class="menu" aria-label="Main">
          <div class="dd"><a href="#{p}#services"#{svc_cur}>Services</a><div class="dd-panel two"><div><span class="mono">Chimney &amp; fireplace</span>#{links(CHIMNEY, current)}</div><div><span class="mono">Home maintenance</span>#{links(HOME_CARE, current)}</div></div></div>
          <div class="dd"><a href="service-areas.html"#{area_cur}>Areas</a><div class="dd-panel areas">#{links(AREAS, current)}<a href="service-areas.html">All service areas</a></div></div>
          <a href="#{p}#work">Our work</a><a href="#{p}#about">About</a><a href="#{p}#process">How it works</a><a href="#{p}#faq">FAQ</a><a href="#{p}#contact">Contact</a>
        </nav>
        #{cta}
      </div>
    </header>
  HTML
end

def footer
  li = ->(list) { list.map { |s| %(<li><a href="#{s[:slug]}.html">#{s[:name]}</a></li>) }.join }
  <<~HTML.chomp
    <footer class="dark">
      <div class="wrap">
        <div class="fgrid">
          <div><p class="tag">Clean chimneys. <em>Cared-for homes.</em></p><p class="sub">Chimney services and home maintenance across Seattle and the Eastside.</p></div>
          <div><h4 class="mono">Chimney &amp; fireplace</h4><ul>#{li.(CHIMNEY)}</ul></div>
          <div><h4 class="mono">Home maintenance</h4><ul>#{li.(HOME_CARE)}</ul></div>
          <div><h4 class="mono"><a href="service-areas.html">Service areas</a></h4><ul>#{li.(AREAS)}</ul></div>
          <div><h4 class="mono">Contact</h4><ul><li><a href="tel:" data-tel data-k="phone">[Phone]</a></li><li><a href="book.html" data-mail data-k="email">[Email]</a></li><li data-k="hours">[Business hours]</li><li data-k="address">[Address]</li><li>WA License <span data-k="license">[License #]</span></li><li data-k="insurance">[Insurance details]</li></ul></div>
        </div>
        <div class="legal mono"><span>© 2026 #{BRAND}</span><span>Serving #{REGION}</span></div>
      </div>
    </footer>
  HTML
end

# ---------------------------------------------------------------- shared bits
HERO_ART = <<~SVG.chomp
  <svg class="hero-art" viewBox="0 0 860 520" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
    <path d="M110 520V470H40L400 200l120 90M610 357.5 760 470h-70v50"/>
    <path d="M520 290V160M610 357.5V160M508 160h114v-20H508z"/>
    <path d="M520 186h90M520 212h90M520 238h90M520 264h90M520 290h90M554.7 316H610M589.3 342H610"/>
    <path d="M565 160v26M550 186v26M580 186v26M565 212v26M550 238v26M580 238v26M565 264v26M580 290v26M595 316v26"/>
    <path d="M552 128c-14-22 20-30 12-52s20-26 14-46M584 128c-10-18 16-26 10-44s14-22 10-36"/>
    <path d="M366 340h30v30h-30zM404 340h30v30h-30zM366 378h30v30h-30zM404 378h30v30h-30z"/>
  </svg>
SVG

# Photos live in assets/photos. To add one: save a JPG there, add an entry here, then use its key
# as `photo:` (page hero) or in `gallery:` on a page below.
PHOTOS = {
  "sweep-roof"      => { src: "assets/photos/chimney-sweep-roof.jpg", w: 1600, h: 1067, tag: "Chimney sweeping", link: "chimney-sweep",
                         title: "Swept from the top", sub: "The flue brushed its full length, with the soot going into the vacuum.",
                         alt: "A Julius Services technician on a roof pushing a round chimney brush down a brick chimney, with a vacuum beside him" },
  "fireplace-clean" => { src: "assets/photos/fireplace-cleaning.jpg", w: 1600, h: 1067, tag: "Fireplace cleaning", link: "chimney-sweep",
                         title: "Firebox cleaning", sub: "Drop cloths down, the vacuum running, and the firebox brushed clean.",
                         alt: "A Julius Services technician brushing soot from the back wall of a stone fireplace, with a drop cloth, a vacuum, and an ash bucket on the hearth" },
  "chimney-cap"     => { src: "assets/photos/chimney-cap.jpg", w: 1600, h: 1067, tag: "Caps &amp; crowns", link: "chimney-caps-liners",
                         title: "Crown &amp; stainless cap", sub: "A sloped crown and a mesh cap keep rain and animals out of the flue.",
                         alt: "A stainless steel chimney cap with mesh sides mounted on a smooth sloped crown on top of a red brick chimney" },
  "duct-clean"      => { src: "assets/photos/air-duct-cleaning.jpg", w: 1600, h: 1200, tag: "Air ducts", link: "air-duct-cleaning",
                         title: "Air duct cleaning", sub: "Ducts brushed and vacuumed, and checked by camera.",
                         alt: "A Julius Services technician feeding a rotating brush into a wall air duct, with a camera monitor showing the inside of the duct" },
  "conv-gas"        => { src: "assets/photos/fireplace-wood-to-gas.jpg", w: 1600, h: 1067, tag: "Conversion", link: "fireplace-services",
                         title: "Wood to gas", sub: "An open wood-burning fireplace fitted with a sealed gas insert.",
                         alt: "Before and after: a sooty open wood-burning brick fireplace, and the same fireplace with a gas insert burning behind glass" },
  "conv-electric"   => { src: "assets/photos/fireplace-gas-to-electric.jpg", w: 1600, h: 1067, tag: "Conversion", link: "fireplace-services",
                         title: "Gas to electric", sub: "A gas fireplace replaced with a wide electric unit. No vent, no gas line.",
                         alt: "Before and after: a gas fireplace in a gray tile surround, and the same wall with a wide linear electric fireplace" },
}

def img_tag(ph, extra = 'loading="lazy"', alt = nil)
  %(<img src="#{ph[:src]}" width="#{ph[:w]}" height="#{ph[:h]}" #{extra} alt="#{alt || ph[:alt]}">)
end

def hero_open(photo, short)
  cls = short ? " short" : ""
  if photo
    ph = PHOTOS.fetch(photo)
    %(<section class="hero dark photo#{cls}" aria-labelledby="h1">\n  <div class="bg">#{img_tag(ph, 'fetchpriority="high"', '')}</div>)
  else
    %(<section class="hero dark plain#{cls}" aria-labelledby="h1">\n  #{HERO_ART})
  end
end

def proj_card(key, i, cls: "", frame: "full", linked: true)
  g = PHOTOS.fetch(key)
  inner = %(#{img_tag(g)}<span class="mono">#{g[:tag]}</span>)
  frame_html = linked ? %(<a class="frame photo #{frame}" href="#{g[:link]}.html">#{inner}</a>) : %(<div class="frame photo #{frame}">#{inner}</div>)
  %(    <article class="proj#{cls}">
      #{frame_html}
      <div class="meta"><div><h3>#{g[:title]}</h3><p>#{g[:sub]}</p></div><span class="mono">0#{i + 1}</span></div>
    </article>)
end

def gallery_html(keys, alt_bg, head = nil)
  return "" if keys.nil? || keys.empty?
  eyebrow, h, p = head || ["A closer look", "The work, <em>up close.</em>", "A look at what this service involves."]
  <<~HTML
    <!-- PHOTOS -->
    <section class="sheet sec" aria-labelledby="work-t"#{alt_bg ? ' style="background:var(--paper-2)"' : ''}>
      <div class="wrap">
        <div class="head">
          <div><p class="eyebrow">#{eyebrow}</p><h2 id="work-t">#{h}</h2></div>
          <p>#{p}</p>
        </div>
      </div>
      <div class="reel" style="grid-template-columns:repeat(#{[keys.size, 3].min},minmax(0,1fr))">
    #{keys.each_with_index.map { |k, i| proj_card(k, i, linked: false) }.join("\n")}
      </div>
    </section>

  HTML
end

ONES = <<~HTML.chomp
  <div class="ones" role="list" aria-label="What to expect">
    <div role="listitem"><span class="n"><i>Safe</i></span><p>Chimneys swept and inspected, so every fire burns the way it should.</p></div>
    <div role="listitem"><span class="n"><i>Dry</i></span><p>Gutters and roofs kept clear, so rain goes where it belongs.</p></div>
    <div role="listitem"><span class="n"><i>Clean</i></span><p>Floors covered, work areas contained, and nothing left behind.</p></div>
    <div role="listitem"><span class="n"><i>Clear</i></span><p>Photos of what we find, and a written price before any repair.</p></div>
  </div>
HTML

def creds
  <<~HTML.chomp
    <dl class="creds">
      <div><dt class="mono">License</dt><dd>WA <span data-k="license">[License #]</span></dd></div>
      <div><dt class="mono">Insurance</dt><dd data-k="insurance">[Insurance details]</dd></div>
      <div><dt class="mono">Hours</dt><dd data-k="hours">[Business hours]</dd></div>
      <div><dt class="mono">Service area</dt><dd>#{REGION}</dd></div>
    </dl>
  HTML
end

PROCESS = <<~HTML
  <ol class="track" style="list-style:none;margin:0;padding-top:0">
    <li class="stage"><span class="no">01</span><div class="pin"></div><h3>Book a visit</h3><p>Tell us what you need and where you are. We confirm a day and an arrival window.</p></li>
    <li class="stage"><span class="no">02</span><div class="pin"></div><h3>We arrive &amp; protect</h3><p>Floors and furniture near the fireplace are covered, and outdoor work areas are set up safely.</p></li>
    <li class="stage"><span class="no">03</span><div class="pin"></div><h3>We look first</h3><p>Before any tools come out, we check the chimney, gutters, roof, or vent and take photos.</p></li>
    <li class="stage"><span class="no">04</span><div class="pin"></div><h3>Clear price</h3><p>You see what we found. If anything beyond the booked service is needed, you get the price first.</p></li>
    <li class="demo" aria-label="Work begins here"><span class="flag mono">Work ▼</span><span class="cut"></span></li>
    <li class="stage"><span class="no">05</span><div class="pin"></div><h3>The work</h3><p>The job you approved, done carefully and by the book.</p></li>
    <li class="stage"><span class="no">06</span><div class="pin"></div><h3>Cleanup &amp; report</h3><p>We clean up, haul away debris, and walk you through what was done, with photos.</p></li>
  </ol>
HTML

def strip_tags(s); s.gsub(/<[^>]+>/, ""); end

def head_html(title, meta, slug)
  full = title == BRAND ? BRAND : "#{title} · #{BRAND}"
  canon = SITE_URL.empty? ? "" : %(\n<link rel="canonical" href="#{SITE_URL}/#{slug}">)
  img = SITE_URL.empty? ? "assets/logo.jpg" : "#{SITE_URL}/assets/logo.jpg"
  <<~HTML.chomp
    <!DOCTYPE html>
    <html lang="en">
    <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>#{full}</title>
    <meta name="description" content="#{meta}">#{canon}
    <meta name="theme-color" content="#0b0a09">
    <link rel="icon" type="image/png" href="assets/favicon.png">
    <link rel="apple-touch-icon" href="assets/apple-touch-icon.png">
    <meta property="og:type" content="website">
    <meta property="og:site_name" content="#{BRAND}">
    <meta property="og:title" content="#{full}">
    <meta property="og:description" content="#{meta}">
    <meta property="og:image" content="#{img}">
    <meta name="twitter:card" content="summary">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,500;0,600;1,500&family=Geist:wght@400;500;600&display=swap" rel="stylesheet">
    <script>document.documentElement.className+=' js'</script>
    <link rel="stylesheet" href="site.css">
    </head>
  HTML
end

def cta_band(h = "Ready to cross it <em>off the list?</em>", svc = nil)
  <<~HTML.chomp
    <section class="cta-band" aria-labelledby="cta-t">
      <div class="wrap">
        <div>
          <h2 id="cta-t">#{h}</h2>
          <p>Tell us what your home needs. We'll confirm a time and take it from there.</p>
        </div>
        <div class="acts">
          <a href="#{book_url(svc)}" class="btn btn-night">Book a service <span class="ar" aria-hidden="true">→</span></a>
          <a href="tel:" data-tel class="btn btn-line-n">Call <span data-k="phone">[Phone]</span></a>
        </div>
      </div>
    </section>
  HTML
end

def tail_html(one: false)
  call = %(<a href="tel:" data-tel class="f-call"><svg viewBox="0 0 24 24" width="17" height="17" aria-hidden="true"><path fill="currentColor" d="M6.6 10.8a15.1 15.1 0 0 0 6.6 6.6l2.2-2.2c.3-.3.7-.4 1-.2 1.1.4 2.3.6 3.6.6.6 0 1 .4 1 1V20c0 .6-.4 1-1 1A17 17 0 0 1 3 4c0-.6.4-1 1-1h3.5c.6 0 1 .4 1 1 0 1.3.2 2.5.6 3.6.1.3 0 .7-.2 1l-2.3 2.2z"/></svg><span>Call <span class="num" data-k="phone">us</span></span></a>)
  cta = one ? "" : %(<a href="book.html" class="f-cta">Book a service <span aria-hidden="true">→</span></a>)
  %(<nav class="mbar#{one ? ' one' : ''}" aria-label="Quick actions">#{call}#{cta}</nav>\n\n<script src="site.js"></script>\n</body>\n</html>\n)
end

def faq_html(list)
  list.each_with_index.map { |(q, a), i|
    %(<details#{i.zero? ? ' open' : ''}><summary><span class="mono">0#{i + 1}</span>#{q}<span class="pm" aria-hidden="true"></span></summary>\n          <p>#{a}</p></details>)
  }.join("\n        ")
end

def rel_html(list)
  list.map { |s| %(<a href="#{s[:slug]}.html">#{s[:name]}<span class="ar" aria-hidden="true">→</span></a>) }.join("\n      ")
end

U = 'style="text-decoration:underline"'

# ---------------------------------------------------------------- service pages
PAGES = [
  # ============================== CHIMNEY SWEEP
  {
    photo: "sweep-roof", gallery: ["sweep-roof", "fireplace-clean"],
    slug: "chimney-sweep", short: "Chimney sweeping",
    title: "Chimney Sweep &amp; Cleaning in #{REGION}",
    meta: "Chimney sweeping in Seattle and the Eastside for wood-burning fireplaces, inserts, and wood and pellet stoves. Soot and creosote removed, floors protected, and a written report with photos.",
    eyebrow: "Chimney sweeping",
    h1: "A clean flue for <em>every fire.</em>",
    lede: "Soot and creosote build up a little with every fire. We sweep the flue from top to bottom, clean the firebox and smoke chamber, and check the parts you can't see, without leaving dust in your living room.",
    tags: ["Fireplaces", "Inserts", "Wood stoves", "Pellet stoves", "Creosote removal", "Photo report"],
    incl_h: "Swept from the cap <em>to the hearth.</em>",
    incl_p: "A sweep is more than a brush down the flue. Here is what's covered on every visit.",
    incl: [
      ["Flue sweeping", "The full length of the flue brushed with rods and brushes sized to your liner, removing soot and creosote."],
      ["Firebox", "Ash and soot cleaned out, and the firebrick and mortar joints checked for cracks and gaps."],
      ["Smoke chamber &amp; shelf", "The area above the damper, where debris and creosote collect, brushed and vacuumed out."],
      ["Damper", "Cleaned and tested to make sure it opens fully and closes tight."],
      ["Cap &amp; crown check", "A look at the cap, crown, and flashing from the roof when it is safe to get up there."],
      ["Floor protection", "Drop cloths from the door to the hearth, and furniture near the fireplace covered."],
      ["Dust control", "A high-filtration vacuum runs the whole time, so soot goes in the canister and not in the room."],
      ["Written report", "Photos and notes on the condition of your chimney, and anything worth watching or repairing."],
    ],
    options: {
      eyebrow: "What we sweep", h: "Every kind of fire <em>needs a clear path.</em>",
      p: "Different appliances collect soot in different places. Tell us what you have when you book, and we'll bring the right brushes.",
      cards: [
        ["Open fireplaces", "Traditional masonry fireplaces and factory-built fireplaces. The flue, smoke chamber, damper, and firebox are all cleaned.", ["Masonry and prefab", "Flue, damper, and firebox", "Checked for cracks and gaps"]],
        ["Inserts &amp; wood stoves", "Stoves and inserts burn hotter and slower, which can glaze the liner with hard creosote. We sweep the liner and clean the baffles and connector pipe.", ["Liner swept end to end", "Baffles and stovepipe cleaned", "Door gaskets checked"]],
        ["Pellet stoves", "Pellet vents are small and clog with fine ash. We clean the vent pipe, the exhaust path, and the ash traps inside the stove.", ["Vent pipe cleaned", "Ash traps cleared", "Better, steadier burn"]],
      ],
    },
    faq: [
      ["How often should a chimney be swept?", "The National Fire Protection Association standard (NFPA 211) calls for chimneys, fireplaces, and vents to be inspected at least once a year and cleaned when needed. If you burn wood regularly through the winter, plan on a sweep every year."],
      ["When is the best time to book?", "Late spring through early fall. The chimney is cool, the weather is dry enough for roof access, and you'll be ready before the first cold night. Fall is the busiest season, so it pays to book early."],
      ["Will sweeping make a mess?", "It shouldn't. We cover the floor and nearby furniture, seal off the fireplace opening while brushing, and run a high-filtration vacuum the whole time."],
      ["How do I know my chimney needs sweeping?", "Common signs are a strong smoky or campfire smell from the fireplace, smoke coming back into the room, black flakes falling into the firebox, or a fire that's hard to start and keep going. If it's been more than a year, it's time for a look either way."],
      ["Do I need to be home?", "Yes. We need to get to the fireplace or stove inside the house, and we'll show you what we found before we leave."],
    ],
  },

  # ============================== INSPECTION
  {
    photo: "fireplace-clean",
    slug: "chimney-inspection", short: "Inspection",
    title: "Chimney Inspections in #{REGION}",
    meta: "Chimney inspections in Seattle and the Eastside: yearly checkups, camera inspections for home sales, and inspections after a chimney fire, earthquake, or storm, with a written photo report.",
    eyebrow: "Chimney inspections",
    h1: "Know what's inside <em>before you light it.</em>",
    lede: "Most chimney problems start where you can't see them: a cracked flue tile, a gap in the smoke chamber, a slow leak at the crown. An inspection finds them early, and tells you plainly what needs attention and what doesn't.",
    tags: ["Yearly checkups", "Home sales", "Camera inspections", "After a chimney fire", "After an earthquake", "Photo report"],
    incl_h: "From the firebox <em>to the cap.</em>",
    incl_p: "Every inspection ends with a written report and photos, so you can see exactly what we saw.",
    incl: [
      ["Firebox &amp; damper", "Firebrick, mortar joints, the damper, and the smoke chamber checked for cracks, gaps, and wear."],
      ["Flue &amp; liner", "The liner checked for cracked tiles, missing mortar, blockages, and creosote buildup."],
      ["Outside the chimney", "Brick and mortar, the crown, the cap, and the flashing checked for damage and leaks."],
      ["Photos &amp; report", "What we found, what it means, and what we recommend, in writing."],
    ],
    options: {
      eyebrow: "Inspection levels", h: "Three levels, <em>one standard.</em>",
      p: "The fire code standard for chimneys, NFPA 211, defines three levels of inspection. We'll tell you which one your situation calls for.",
      label: "Level",
      cards: [
        ["Yearly checkup", "For a chimney you use the same way every year with no known problems. We examine the parts that can be reached without tools or special equipment, and confirm the flue is clear.", ["Same appliance, same fuel", "Readily accessible areas", "Usually done with a sweep"]],
        ["Camera inspection", "Required when a home is sold or transferred, when you change the appliance or fuel, and after a chimney fire, earthquake, or severe weather. Includes a camera scan of the inside of the flue.", ["Buying or selling a home", "After a fire, quake, or storm", "Video scan of the flue"]],
        ["Hidden areas", "When a Level 1 or 2 inspection points to a serious hazard that can't be seen any other way. It can involve opening up part of the chimney or the wall around it.", ["Only when a hazard is suspected", "Concealed areas opened", "Scope agreed with you first"]],
      ],
      table: {
        caption: "Inspection levels at a glance",
        cols: ["Level 1", "Level 2", "Level 3"],
        rows: [
          ["When", "Yearly, nothing has changed", "Home sale, new appliance or fuel, or after a fire, earthquake, or storm", "A hidden hazard is suspected"],
          ["What's examined", "Readily accessible parts of the chimney and appliance", "Level 1, plus accessible attics, crawl spaces, and the inside of the flue", "Level 2, plus concealed areas"],
          ["Camera scan of the flue", "Not usually", "Yes", "Yes"],
          ["Opening walls or chimney", "No", "No", "When necessary"],
        ],
      },
    },
    faq: [
      ["I'm buying a house. Which inspection do I need?", "A Level 2 inspection. A general home inspector looks at the chimney from the outside and the firebox, but not the inside of the flue. A camera scan shows cracked tiles and gaps that would otherwise stay hidden until after you move in."],
      ["Should I have my chimney checked after an earthquake?", "Yes. Masonry chimneys are one of the first parts of a house to crack in an earthquake, and the damage is often inside the flue or below the roofline where you can't see it. Have it inspected before you use the fireplace again."],
      ["How often should a chimney be inspected?", "At least once a year, according to NFPA 211, even if you don't use the fireplace much. Animals, moisture, and settling cause problems whether or not you burn."],
      ["What do I get at the end?", "A written report with photos: the condition of each part of the chimney, anything that needs repair, and what can simply be watched."],
      ["Is an inspection the same as a sweep?", "No. A sweep removes soot and creosote. An inspection examines the chimney's condition. A basic inspection is part of every sweep, and a camera inspection can be added to it."],
    ],
  },

  # ============================== REPAIR
  {
    photo: "chimney-cap",
    slug: "chimney-repair", short: "Chimney repair",
    title: "Chimney Repair &amp; Masonry in #{REGION}",
    meta: "Chimney repair in Seattle and the Eastside: tuckpointing, brick replacement, crown repair, flashing, leak repair, waterproofing, firebox repair, and partial rebuilds.",
    eyebrow: "Chimney repair",
    h1: "Stop the leak. <em>Save the chimney.</em>",
    lede: "Northwest rain finds every weak spot in a chimney: a cracked crown, tired mortar, loose flashing. We repair the masonry and seal out the water, so a small problem doesn't turn into a rebuild.",
    tags: ["Tuckpointing", "Crown repair", "Flashing", "Leak repair", "Waterproofing", "Firebox repair"],
    incl_h: "Masonry repairs, <em>top to bottom.</em>",
    incl_p: "Water is behind most chimney damage. We fix what's broken and deal with how the water got in.",
    incl: [
      ["Tuckpointing", "Crumbling mortar joints ground out and repointed with new mortar matched to the old."],
      ["Brick replacement", "Cracked, loose, or flaking bricks cut out and replaced with matching brick."],
      ["Crown repair", "Cracked crowns sealed or rebuilt with a proper slope and drip edge, so water runs off the top."],
      ["Flashing", "Loose or failed flashing where the chimney meets the roof repaired, resealed, or replaced."],
      ["Waterproofing", "A breathable water repellent applied to sound masonry, so rain stays out and moisture inside can still escape."],
      ["Firebox repair", "Cracked firebrick replaced and joints repointed with heat-rated refractory mortar."],
      ["Smoke chamber", "Rough, gapped smoke chambers smoothed and sealed with a heat-rated coating for better draft."],
      ["Partial rebuilds", "When the top of the chimney is too far gone to repair, it is rebuilt from the roofline up."],
    ],
    options: {
      eyebrow: "Your options", h: "Seal, repair, <em>or rebuild.</em>",
      p: "We'll show you photos of the damage and recommend the smallest repair that will actually last.",
      cards: [
        ["Seal &amp; protect", "For a chimney that's sound but starting to take on water. Hairline crown cracks sealed, flashing resealed, and the masonry treated with a water repellent.", ["Sound brick and mortar", "Stops early leaks", "Least cost"]],
        ["Repair &amp; repoint", "For worn mortar joints, a few damaged bricks, or a cracked crown. Joints repointed, bricks replaced, and the crown rebuilt.", ["Crumbling mortar", "Flaking or loose bricks", "New crown"]],
        ["Rebuild from the roofline", "For a chimney top that's leaning, loose, or badly weathered. The damaged section is taken down and rebuilt with new brick, crown, and cap.", ["Leaning or loose top", "New brick, crown, and cap", "Longest lasting"]],
      ],
      table: {
        caption: "Repair options at a glance",
        cols: ["Seal &amp; protect", "Repair &amp; repoint", "Rebuild"],
        rows: [
          ["Best for", "Early signs of water", "Worn joints and damaged bricks", "Tops that are loose or leaning"],
          ["Masonry work", "Minimal", "Joints and individual bricks", "Whole section rebuilt"],
          ["Time on site", "Shortest", "Moderate", "Longest"],
          ["Budget", "$", "$$", "$$$"],
        ],
      },
    },
    faq: [
      ["Why is my chimney leaking?", "The usual causes are a cracked crown, a missing or damaged cap, failed flashing where the chimney meets the roof, and worn mortar joints that soak up rain. We find the source first, because sealing the wrong spot doesn't stop the leak."],
      ["What is the white staining on my chimney?", "It's called efflorescence: salts left behind when water moves through the brick and evaporates. The stain itself is harmless, but it tells you the chimney is taking on water."],
      ["Can masonry repairs be done in winter?", "Some can. Mortar needs to cure above freezing and out of the rain, so larger masonry jobs are usually scheduled for drier weather. An urgent leak can be covered and protected until then."],
      ["My chimney was damaged in an earthquake. Can it be repaired?", "Often, yes. It starts with a Level 2 inspection to see how far the damage goes. <a href=\"chimney-inspection.html\" #{U}>See how inspections work</a>."],
      ["Is waterproofing just a coat of sealant?", "No. Ordinary sealers and paint trap moisture inside the brick, which makes damage worse. A breathable water repellent keeps rain out while letting moisture escape."],
    ],
  },

  # ============================== CAPS / LINERS
  {
    photo: "chimney-cap",
    slug: "chimney-caps-liners", short: "Cap &amp; liner",
    title: "Chimney Caps, Dampers &amp; Liners in #{REGION}",
    meta: "Chimney caps, chase covers, top-sealing dampers, and stainless steel chimney liners installed in Seattle and the Eastside. Keep out rain, animals, and downdrafts.",
    eyebrow: "Caps, dampers &amp; liners",
    h1: "Keep the rain out <em>and the smoke going up.</em>",
    lede: "A chimney without a cap is an open hole in your roof. We install caps, chase covers, top-sealing dampers, and stainless steel liners that keep water and animals out and help your fireplace draw the way it should.",
    tags: ["Chimney caps", "Chase covers", "Top-sealing dampers", "Stainless liners", "Animal guards"],
    incl_h: "The parts that <em>protect the flue.</em>",
    incl_p: "Small parts, big job. Each one is measured for your chimney and installed to stay put.",
    incl: [
      ["Chimney caps", "Stainless steel or copper caps with mesh sides that keep out rain, leaves, birds, and squirrels."],
      ["Chase covers", "For factory-built chimneys: a new sloped metal cover to replace a rusted one that's letting water in."],
      ["Top-sealing dampers", "A damper at the top of the flue with a gasket seal, for when the old throat damper is rusted or missing."],
      ["Stainless steel liners", "A new liner sized to your fireplace, insert, or stove, for a safe and properly drafting flue."],
    ],
    options: {
      eyebrow: "Liners", h: "When a chimney <em>needs a new liner.</em>",
      p: "The liner is what contains the heat and smoke on the way up. An inspection tells us whether yours is doing its job.",
      label: "Reason",
      cards: [
        ["Cracked clay tiles", "Older chimneys are lined with clay tiles that crack with age, heat, and settling. Cracks let heat and smoke reach the brick and the framing around it.", ["Found by camera inspection", "Common in older homes", "Relined in stainless steel"]],
        ["A new insert or stove", "An insert or stove needs a liner sized to its outlet. Venting it into a large open flue causes poor draft and fast creosote buildup.", ["Sized to the appliance", "Better draft", "Cleaner burn"]],
        ["No liner at all", "Some older chimneys were built without a liner. Bare brick and mortar break down from heat and the acids in smoke.", ["Older chimneys", "Protects the masonry", "Brings the flue up to standard"]],
      ],
    },
    faq: [
      ["Do I really need a chimney cap?", "Yes. A cap keeps rain from running straight down the flue, keeps birds, squirrels, and raccoons from moving in, and stops leaves and needles from blocking it. It's one of the least expensive ways to protect a chimney."],
      ["There are birds or animals in my chimney. What can you do?", "We can install a cap with mesh to keep animals out. Some birds are protected by federal law while they're nesting, so timing matters. We'll tell you what can be done and when."],
      ["What is a chase cover?", "Factory-built fireplaces often vent through a wood-framed box called a chase, with a metal cover on top. The original covers are usually thin steel that rusts through, which lets water into the chase. A sloped stainless steel cover fixes it."],
      ["What does a top-sealing damper do?", "It closes the flue at the top with a rubber gasket, which seals much tighter than an old cast-iron damper. That keeps out rain and animals, and keeps heated air from escaping up the chimney when the fireplace isn't in use."],
    ],
  },

  # ============================== FIREPLACES
  {
    photo: "fireplace-clean", gallery: ["conv-gas", "conv-electric"],
    gallery_head: ["Conversions", "Before <em>and after.</em>", "What a conversion looks like in the same fireplace opening."],
    slug: "fireplace-services", short: "Fireplace",
    title: "Fireplace, Insert &amp; Wood Stove Service in #{REGION}",
    meta: "Fireplace, insert, wood stove, and pellet stove cleaning and service in Seattle and the Eastside, including smoky fireplace and draft problems.",
    eyebrow: "Fireplaces &amp; stoves",
    h1: "Fireplaces that draw well <em>and burn clean.</em>",
    lede: "A fireplace should light easily, pull smoke up the chimney, and leave the room smelling like nothing at all. If yours doesn't, we find out why, and get it burning the way it should.",
    tags: ["Wood fireplaces", "Inserts", "Wood stoves", "Pellet stoves", "Conversions", "Smoke problems"],
    incl_h: "Service for <em>whatever you burn in.</em>",
    incl_p: "Cleaning, checks, and repairs for the appliance itself, alongside the chimney above it.",
    incl: [
      ["Open fireplaces", "Firebox cleaning, damper service, firebrick and mortar repair, and a check of the smoke chamber."],
      ["Fireplace inserts", "The insert pulled or accessed for cleaning, the liner swept, and door gaskets and baffles checked."],
      ["Wood &amp; pellet stoves", "Stovepipe and vent cleaning, baffles and ash traps cleared, and gaskets checked for a tight seal."],
      ["Smoke &amp; odor problems", "Smoke in the room, slow starts, and smells in damp weather traced to their cause and fixed."],
    ],
    options: {
      eyebrow: "Fireplace conversions", h: "Change the way <em>your fireplace burns.</em>",
      p: "If your fireplace is more work than you want, or just isn't being used, it can be converted. We'll look at the fireplace and the chimney and tell you which options fit.",
      cards: [
        ["Wood to gas", "A gas insert fitted into your existing wood-burning fireplace. A fire at the push of a button, with no wood to carry and no ash to clean out.", ["Uses the existing opening", "No wood, no ash", "Needs a gas line and a vent liner"]],
        ["Gas to electric", "An electric fireplace in place of an older gas unit. It needs no vent and no gas line, and it can run with or without heat.", ["No venting needed", "Flame with or without heat", "Simple to live with"]],
        ["Keep it wood-burning", "Nothing replaces a real wood fire. A high-efficiency wood insert and a properly sized liner give you far more heat from the same fireplace.", ["Real wood fire", "Much more heat into the room", "Sized stainless liner"]],
      ],
    },
    faq: [
      ["Can any wood-burning fireplace be converted to gas?", "Most can. It depends on the size of the firebox, the condition of the chimney, and whether a gas line can reach the fireplace. We check all three before recommending it."],
      ["Why does my fireplace smoke into the room?", "The common causes are a dirty or blocked flue, a damper that isn't fully open, a cold flue that needs warming before the fire is lit, or a house that's sealed so tightly the chimney can't pull enough air. We check each one."],
      ["Why does my fireplace smell, especially when it rains?", "Creosote and soot in the flue smell stronger when they get damp, and air moving down the chimney carries the smell into the house. A sweep, a cap, and a tight-sealing damper usually solve it."],
      ["Can I use my fireplace during a burn ban?", "The Puget Sound Clean Air Agency calls burn bans when air quality is poor, and they restrict the use of fireplaces and wood stoves unless wood is your only adequate source of heat. Check the agency's current status before lighting a fire."],
      ["What should I burn?", "Dry, seasoned firewood, split and stored under cover for at least six months to a year. Wet wood, trash, and treated lumber make more smoke and far more creosote."],
    ],
  },

  # ============================== GUTTERS
  {
    slug: "gutter-cleaning", short: "Gutter",
    title: "Gutter Cleaning &amp; Gutter Guards in #{REGION}",
    meta: "Gutter cleaning in Seattle and the Eastside: gutters cleared by hand, downspouts flushed, roof debris removed, minor repairs, and gutter guards, with before and after photos.",
    eyebrow: "Gutter cleaning",
    h1: "Gutters that <em>actually drain.</em>",
    lede: "Fir needles, maple leaves, and moss fill Northwest gutters faster than you'd think. We clear the gutters, flush the downspouts, and make sure the water ends up away from your house.",
    tags: ["Gutter cleaning", "Downspouts flushed", "Roof debris", "Minor repairs", "Gutter guards", "Before &amp; after photos"],
    incl_h: "Cleared, flushed, <em>and checked.</em>",
    incl_p: "A proper gutter cleaning doesn't stop at scooping out leaves.",
    incl: [
      ["Gutters cleared", "Leaves, needles, moss, and roof grit removed from every run by hand."],
      ["Downspouts flushed", "Each downspout run with water to prove it's clear, and clogs worked loose."],
      ["Roof debris", "Loose leaves and needles blown off the roof and valleys, so they don't wash straight back in."],
      ["Minor repairs", "Loose hangers re-secured and leaking seams and end caps sealed while we're up there."],
      ["Gutter guards", "Guards installed over clean gutters to cut down on how often they need attention."],
      ["Cleanup", "Debris bagged and hauled away, and walks, decks, and patios below rinsed or blown clean."],
      ["Photos", "Before and after photos, so you can see the result without climbing a ladder."],
      ["Problems flagged", "Sagging runs, rot at the fascia, and downspouts that drain too close to the house pointed out."],
    ],
    options: {
      eyebrow: "Your options", h: "Once, twice a year, <em>or guarded.</em>",
      p: "How often your gutters need cleaning depends mostly on the trees around your house.",
      cards: [
        ["One-time cleaning", "A full cleaning whenever you need it: before winter rain, before a home sale, or when the gutters start to overflow.", ["Gutters and downspouts", "Roof blown off", "Before and after photos"]],
        ["Twice a year", "The schedule most Northwest homes need: once in late fall after the leaves drop, and once in spring after the winter storms.", ["Late fall and spring", "Set it and forget it", "Problems caught early"]],
        ["Gutter guards", "Guards keep leaves and most needles out, so gutters flow longer between cleanings. They still need a check from time to time.", ["Less buildup", "Fewer cleanings", "Good for homes under trees"]],
      ],
    },
    faq: [
      ["How often should gutters be cleaned around Seattle?", "At least twice a year for most homes: in late fall once the leaves are down, and again in spring. Homes under fir, cedar, or big-leaf maple often need a third visit."],
      ["What happens if I skip it?", "Clogged gutters overflow. The water runs down the siding and behind the fascia, rots the wood, and pools at the foundation, where it can find its way into a crawl space or basement."],
      ["Do gutter guards mean I never clean my gutters again?", "No. Guards cut the buildup a great deal, but fine debris and moss still get through, and needles can mat on top. Plan on a check every year or two."],
      ["Do I need to be home?", "Usually not. As long as we can reach all sides of the house and an outdoor water spigot, we can do the work and send you the photos."],
    ],
  },

  # ============================== ROOF / MOSS
  {
    slug: "roof-cleaning-moss-removal", short: "Roof &amp; moss",
    title: "Roof Cleaning &amp; Moss Removal in #{REGION}",
    meta: "Roof cleaning and moss removal in Seattle and the Eastside: moss removed without high pressure, debris cleared, and treatment applied to slow regrowth.",
    eyebrow: "Roof cleaning &amp; moss removal",
    h1: "Get the moss off <em>before it lifts the shingles.</em>",
    lede: "Moss holds water against your roof and works its way under the shingles. We remove it with methods suited to your roofing, clear the debris, and treat the roof to slow it from coming back.",
    tags: ["Moss removal", "Roof blow-off", "Moss treatment", "Asphalt shingles", "Tile &amp; metal", "Gutters cleared after"],
    incl_h: "Off the roof, <em>out of the gutters.</em>",
    incl_p: "Roof cleaning done wrong shortens a roof's life. We clean in a way that protects it.",
    incl: [
      ["Moss removal", "Moss loosened and removed by brushing and other low-impact methods matched to your roofing."],
      ["Debris cleared", "Leaves, needles, and branches blown off the roof, valleys, and behind the chimney."],
      ["Moss treatment", "A treatment applied to kill what's left in the shingles and slow regrowth."],
      ["Gutters cleared", "Everything that comes off the roof is cleaned out of the gutters and downspouts afterward."],
    ],
    options: {
      eyebrow: "Your options", h: "From a quick blow-off <em>to a full treatment.</em>",
      p: "We'll look at the roof and recommend what it needs, which is often less than you'd expect.",
      cards: [
        ["Roof blow-off", "For roofs with needles and leaves but little moss. Debris is blown off the roof and valleys and cleared from the gutters.", ["Needles and leaves", "Valleys cleared", "Good yearly upkeep"]],
        ["Moss removal &amp; treatment", "For roofs with visible moss. The moss is removed, the roof is cleared, and a treatment is applied to slow it from returning.", ["Visible moss", "Low-impact removal", "Treatment applied"]],
        ["Roof &amp; gutters together", "Moss removal, treatment, and a full gutter cleaning in one visit, so everything that comes off the roof leaves the property.", ["One visit", "Roof and gutters done", "Best before winter"]],
      ],
    },
    faq: [
      ["Why is moss bad for a roof?", "Moss holds moisture against the roofing and its roots work under the edges of shingles, lifting them. That lets water in and wears the roof out years early."],
      ["Do you pressure wash roofs?", "Not asphalt shingle roofs. High pressure strips off the granules that protect the shingles. Moss on shingles is removed with gentler methods and then treated. Some tile and metal roofs can be washed at low pressure."],
      ["How long does moss treatment last?", "It depends on shade, trees, and which way the roof faces. A sunny roof may stay clear for several years. A shaded north-facing roof under trees may need attention every year or two."],
      ["When is the best time for moss removal?", "Dry weather makes roof work safer and helps treatments work, so late spring through early fall is ideal. If moss is already lifting shingles, don't wait for the perfect season."],
    ],
  },

  # ============================== DRYER VENT
  {
    slug: "dryer-vent-cleaning", short: "Dryer vent",
    title: "Dryer Vent Cleaning in #{REGION}",
    meta: "Dryer vent cleaning in Seattle and the Eastside: the full vent line brushed and cleared from the dryer to the outside wall, with airflow checked before and after.",
    eyebrow: "Dryer vent cleaning",
    h1: "Shorter dry times. <em>Lower fire risk.</em>",
    lede: "The lint screen catches most of the lint, not all of it. The rest packs into the vent line behind the wall. We clear the whole run from the dryer to the outside, so your dryer breathes again.",
    tags: ["Full vent line", "Behind the dryer", "Outside vent hood", "Airflow check", "Bird nests removed"],
    incl_h: "From the dryer <em>to the outside wall.</em>",
    incl_p: "Cleaning only the first few feet doesn't solve the problem. We clean the entire run.",
    incl: [
      ["Full vent line", "The whole duct brushed and vacuumed, including long runs through walls, floors, crawl spaces, and attics."],
      ["Behind the dryer", "The transition hose and the dryer's exhaust outlet cleared, and crushed or kinked hose pointed out."],
      ["Outside vent hood", "The exterior hood and flap cleaned of lint and nests, and checked to make sure the flap opens freely."],
      ["Airflow check", "Airflow checked before and after, so you can see the difference."],
    ],
    options: {
      eyebrow: "Warning signs", h: "Is your dryer <em>telling you something?</em>",
      p: "A clogged vent shows itself in a few ways. Any one of these is worth a look.",
      label: "Sign",
      cards: [
        ["Clothes take two cycles", "When moist air can't get out, clothes stay damp. Long dry times are the most common sign of a blocked vent.", ["Loads still damp", "Longer and longer cycles", "Higher energy use"]],
        ["The dryer runs hot", "The top of the dryer, the clothes, or the laundry room feels much hotter than usual, or the dryer shuts off mid-cycle.", ["Hot to the touch", "Burning smell", "Shuts off early"]],
        ["Nothing comes out outside", "With the dryer running, the flap on the outside wall barely opens, or there's lint built up around it.", ["Flap stays closed", "Lint around the hood", "Birds or nests"]],
      ],
    },
    faq: [
      ["How often should a dryer vent be cleaned?", "About once a year for most households. Large families, homes with pets, and dryers with long vent runs often need it more often."],
      ["Is a clogged dryer vent really a fire hazard?", "Yes. Lint is highly flammable, and a blocked vent makes the dryer run hotter. Failure to clean is a leading cause of home dryer fires."],
      ["My vent runs a long way to the outside. Can you still clean it?", "Yes. Long runs through crawl spaces, attics, and between floors are the ones that clog first, and we have the rods and brushes to clean their full length."],
      ["Should my flexible foil or plastic vent hose be replaced?", "Usually, yes. Plastic and thin foil hose sags, crushes, and traps lint. Rigid or semi-rigid metal duct moves air better and is what dryer manufacturers call for."],
    ],
  },

  # ============================== AIR DUCTS
  {
    photo: "duct-clean",
    slug: "air-duct-cleaning", short: "Air duct",
    title: "Air Duct Cleaning in #{REGION}",
    meta: "Air duct cleaning in Seattle and the Eastside: supply and return ducts brushed and vacuumed, registers cleaned, and a camera check before and after.",
    eyebrow: "Air duct cleaning",
    h1: "Clear out what's <em>hiding in the ducts.</em>",
    lede: "Years of dust, pet hair, and construction debris settle inside the ductwork, out of sight. We brush and vacuum the ducts from the registers back to the furnace, and show you the inside before and after.",
    tags: ["Supply ducts", "Return ducts", "Registers &amp; grilles", "Camera check", "After remodeling"],
    incl_h: "Every run, <em>from register to furnace.</em>",
    incl_p: "The whole system is cleaned, and you see the inside of the ducts for yourself.",
    incl: [
      ["Supply &amp; return ducts", "Each duct run brushed loose with rotating brushes while a vacuum pulls the debris out."],
      ["Registers &amp; grilles", "Vent covers removed, cleaned, and put back."],
      ["Main trunk lines", "The large ducts near the furnace, where the most debris settles, cleaned out."],
      ["Camera check", "A camera look inside the ducts before and after, so you can see the difference."],
    ],
    options: {
      eyebrow: "When it's worth doing", h: "Ducts don't need cleaning <em>every year.</em>",
      p: "There is no fixed schedule for air ducts. These are the times it makes the most sense.",
      label: "Reason",
      cards: [
        ["After a remodel", "Drywall dust and sawdust get pulled into the return ducts during construction, then blow back out for months afterward.", ["Drywall and sawdust", "New construction too", "Clean before you move back in"]],
        ["Moving into a home", "You don't know what the last owners left behind. A cleaning and a camera check give you a fresh start and a look at the ductwork's condition.", ["Unknown history", "Camera look inside", "Fresh start"]],
        ["Visible buildup", "Dust blowing from the vents, heavy buildup on the registers, pet hair, or signs of rodents or mold in the ducts.", ["Dust from the vents", "Pets in the home", "Signs of pests or mold"]],
      ],
    },
    faq: [
      ["How often should air ducts be cleaned?", "Only as needed. The U.S. Environmental Protection Agency recommends cleaning ducts when there is visible mold, signs of rodents or insects, or enough dust and debris that it's blowing into the house. After a remodel is another good time."],
      ["Will I be able to see the difference?", "Yes. We look inside the ducts with a camera before and after, and show you both."],
      ["Is this the same as dryer vent cleaning?", "No. Air ducts carry heated and cooled air through the house. The dryer vent carries lint and moist air outside. They are cleaned separately, and both can be done in the same visit. <a href=\"dryer-vent-cleaning.html\" #{U}>About dryer vent cleaning</a>."],
      ["What else keeps ducts clean?", "Changing the furnace filter on schedule does more than anything else. We can show you where yours is and what size it takes."],
    ],
  },

  # ============================== PRESSURE WASHING
  {
    slug: "pressure-washing", short: "Pressure washing",
    title: "Pressure Washing in #{REGION}",
    meta: "Pressure washing and soft washing in Seattle and the Eastside: driveways, walkways, patios, decks, fences, and siding cleaned of moss, algae, and grime.",
    eyebrow: "Pressure washing",
    h1: "Bring back <em>the original color.</em>",
    lede: "Months of rain leave concrete green, decks slick, and siding dull. We wash away the moss, algae, and grime with the right pressure for each surface, so it comes clean without damage.",
    tags: ["Driveways", "Walkways", "Patios", "Decks &amp; fences", "Siding", "Soft washing"],
    incl_h: "Every surface, <em>the right pressure.</em>",
    incl_p: "Concrete can take high pressure. Wood and siding can't. We adjust for each one.",
    incl: [
      ["Driveways", "Tire marks, moss, and built-up grime lifted from concrete, asphalt, and pavers."],
      ["Walkways &amp; steps", "Slippery green algae cleaned off paths, steps, and landings for safer footing."],
      ["Patios &amp; pavers", "Concrete, stone, and paver patios cleaned evenly, without stripe marks."],
      ["Decks", "Wood and composite decking cleaned at low pressure, with the grain, to avoid gouging."],
      ["Fences", "Gray, weathered, and mossy fences cleaned and brightened."],
      ["Siding", "Soft washed with low pressure and a cleaning solution, so water isn't forced behind the boards."],
      ["Retaining walls", "Block, stone, and concrete walls cleaned of moss and staining."],
      ["Garage floors", "Dust, dirt, and surface stains washed out of concrete garage floors."],
    ],
    options: {
      eyebrow: "Methods", h: "Pressure wash, soft wash, <em>or wood care.</em>",
      p: "The method matters more than the machine. Here is how we match it to the surface.",
      label: "Method",
      cards: [
        ["Pressure washing", "High-pressure water for hard surfaces that can take it. A surface cleaner keeps the result even across large areas.", ["Concrete and stone", "Driveways, walks, patios", "Even, stripe-free finish"]],
        ["Soft washing", "Low pressure and a cleaning solution that does the work, then a gentle rinse. For surfaces that high pressure would damage.", ["Siding and trim", "Painted surfaces", "Kills algae at the root"]],
        ["Wood care", "Wide spray, low pressure, and careful technique for decks and fences, so the wood comes clean without raised grain or gouges.", ["Decks and fences", "Low pressure", "Ready for stain or sealer"]],
      ],
      table: {
        caption: "Washing methods at a glance",
        cols: ["Pressure washing", "Soft washing", "Wood care"],
        rows: [
          ["Best for", "Concrete, stone, pavers", "Siding, trim, painted surfaces", "Decks and fences"],
          ["Pressure", "High", "Low", "Low"],
          ["What does the cleaning", "Water pressure", "Cleaning solution and a rinse", "Low pressure and technique"],
        ],
      },
    },
    faq: [
      ["Can pressure washing damage my home?", "It can if it's done with too much pressure or the wrong tip. High pressure gouges wood, strips paint, and forces water behind siding. That's why we soft wash siding and use low pressure on wood."],
      ["Do you use my water?", "Yes. We connect to an outdoor spigot at your home. Let us know when you book if you don't have one that works."],
      ["How often should driveways and walkways be washed?", "Once a year keeps most concrete clean around here. Shaded areas that stay damp grow algae faster and may need it more often."],
      ["Do I need to be home?", "Usually not, as long as we can reach the areas being cleaned and an outdoor water spigot. Please move cars and patio furniture beforehand if you can."],
    ],
  },
]

def options_html(o)
  return "" unless o
  label = o[:label] || "Option"
  cards = o[:cards].each_with_index.map { |(h, p, bullets), i|
    %(      <article class="opt#{i == o[:cards].size - 1 ? ' feat' : ''}">
        <span class="mono">#{label} 0#{i + 1}</span>
        <h3>#{h}</h3>
        <p>#{p}</p>
        <ul>#{bullets.map { |b| "<li>#{b}</li>" }.join}</ul>
      </article>)
  }.join("\n")
  table = ""
  if (t = o[:table])
    head = t[:cols].map { |c| %(<th scope="col">#{c}</th>) }.join
    body = t[:rows].map { |r| %(<tr><th scope="row">#{r[0]}</th>#{r[1..-1].map { |c| "<td>#{c}</td>" }.join}</tr>) }.join("\n          ")
    table = <<~T
      <div class="cmp-wrap">
        <table class="cmp">
          <caption class="mono">#{t[:caption]}</caption>
          <thead><tr><th scope="col"></th>#{head}</tr></thead>
          <tbody>
          #{body}
          </tbody>
        </table>
      </div>
    T
  end
  <<~HTML
    <!-- OPTIONS -->
    <section class="sheet sec" id="options" aria-labelledby="opt-t">
      <div class="wrap">
        <div class="head">
          <div><p class="eyebrow">#{o[:eyebrow]}</p><h2 id="opt-t">#{o[:h]}</h2></div>
          <p>#{o[:p]}</p>
        </div>
        <div class="opts">
    #{cards}
        </div>
    #{table}  </div>
    </section>

  HTML
end

def page(pg)
  svc = ALL.find { |s| s[:slug] == pg[:slug] }
  tags = pg[:tags].map { |t| "<li>#{t}</li>" }.join
  incl = pg[:incl].each_with_index.map { |(h, p), i| %(<div><span class="mono" style="color:var(--gold)">0#{i + 1}</span><h3>#{h}</h3><p>#{p}</p></div>) }.join("\n      ")
  n = pg[:options] ? 1 : 0
  gal = gallery_html(pg[:gallery], n.odd?, pg[:gallery_head])
  n += 1 unless gal.empty?
  alt = ' style="background:var(--paper-2)"'
  proc_bg = n.odd? ? alt : ""
  faq_bg  = n.even? ? alt : ""
  rel_bg  = n.odd? ? alt : ""

  <<~HTML
    #{head_html(pg[:title], pg[:meta], pg[:slug])}
    <body>

    #{header(pg[:slug])}

    <main id="top">

    <!-- HERO -->
    #{hero_open(pg[:photo], true)}
      <div class="wrap hero-in">
        <p class="eyebrow">#{pg[:eyebrow]}</p>
        <h1 id="h1">#{pg[:h1]}</h1>
        <p class="lede">#{pg[:lede]}</p>
        <div class="hero-ctas">
          <a href="#{book_url(svc)}" class="btn btn-brass">Book this service <span class="ar" aria-hidden="true">→</span></a>
          <a href="tel:" data-tel class="btn btn-line">Call <span data-k="phone">[Phone]</span></a>
        </div>
        <ul class="tags" aria-label="What's included">#{tags}</ul>
      </div>
      <div class="wrap">
        #{creds}
      </div>
    </section>

    #{ONES}

    <!-- INCLUDED -->
    <section class="dark sec" aria-labelledby="incl-t">
      <div class="wrap">
        <div class="head">
          <div><p class="eyebrow">What's included</p><h2 id="incl-t">#{pg[:incl_h]}</h2></div>
          <p>#{pg[:incl_p]}</p>
        </div>
        <div class="incl">
          #{incl}
        </div>
      </div>
    </section>

    #{options_html(pg[:options])}#{gal}<!-- PROCESS -->
    <section class="sheet sec" aria-labelledby="proc-t"#{proc_bg}>
      <div class="wrap">
        <div class="head">
          <div><p class="eyebrow">How it works</p><h2 id="proc-t">A simple visit. <em>No surprises.</em></h2></div>
          <p>Four of the six steps happen before any work begins, so you always know what's being done and why.</p>
        </div>
    #{PROCESS.gsub(/^/, '    ').chomp}
      </div>
    </section>

    <!-- FAQ -->
    <section class="sheet sec" aria-labelledby="faq-t"#{faq_bg}>
      <div class="wrap">
        <div class="faq">
          <div class="head">
            <div><p class="eyebrow">FAQ</p><h2 id="faq-t">#{pg[:short]} <em>questions.</em></h2></div>
            <p>Anything else, ask us when you book.</p>
          </div>
          <div>
            #{faq_html(pg[:faq])}
          </div>
        </div>
      </div>
    </section>

    <!-- OTHER SERVICES -->
    <section class="sheet sec" aria-labelledby="rel-t"#{rel_bg}>
      <div class="wrap">
        <div class="head">
          <div><p class="eyebrow">More services</p><h2 id="rel-t">While we're <em>at your home.</em></h2></div>
          <p>Many of these can be done in the same visit.</p>
        </div>
        <div class="rel">
          #{rel_html(ALL.reject { |s| s[:slug] == pg[:slug] })}
        </div>
      </div>
    </section>

    #{cta_band("Ready to cross it <em>off the list?</em>", svc)}

    </main>

    #{footer}

    #{tail_html}
  HTML
end

# ================================================================ CITY PAGES
# Each city has its own wording so the pages are genuinely different
# (search engines ignore near-identical "city name swapped" pages).
CITY_PAGES = {
  "chimney-services-seattle-wa" => {
    h1: "Seattle chimneys and homes, <em>looked after.</em>",
    lede: "Chimney sweeping, inspections, and repairs, plus gutter, roof, dryer vent, and pressure washing services for Seattle homes, from century-old Craftsmans to newer townhomes.",
    homes_h: "Old chimneys need <em>a closer look.</em>",
    homes: [
      "Many Seattle neighborhoods are full of early-1900s Craftsmans, bungalows, and Tudors with their original brick chimneys. After a hundred years of rain and more than one earthquake, those chimneys often have worn mortar, cracked crowns, and clay liners that are cracked or missing altogether.",
      "Add mature street trees that fill gutters every fall and shaded roofs where moss takes hold, and a Seattle home has plenty to keep up with. We take care of all of it.",
    ],
    hoods: ["Ballard", "Capitol Hill", "Queen Anne", "Magnolia", "Fremont", "Wallingford", "Green Lake", "Ravenna", "West Seattle", "Madison Park"],
    nearby: %w[chimney-services-shoreline-wa chimney-services-mercer-island-wa chimney-services-bellevue-wa],
  },
  "chimney-services-bellevue-wa" => {
    h1: "Bellevue home care, <em>from the chimney down.</em>",
    lede: "Chimney sweeping and repair, gutter cleaning, moss removal, dryer vent cleaning, and pressure washing for homes across Bellevue.",
    homes_h: "Mid-century fireplaces, <em>kept in working order.</em>",
    homes: [
      "Much of Bellevue was built in the 1950s through the 1970s, and many of those ramblers and split-levels were built around a brick fireplace. Decades later, those chimneys are due for inspection, and often for new crowns, caps, and mortar work.",
      "Bellevue's tall firs and cedars drop needles year-round. Gutters fill quickly, and roofs on wooded lots grow moss on the shaded side. A regular cleaning schedule keeps the water moving.",
    ],
    hoods: ["Downtown Bellevue", "West Bellevue", "Enatai", "Somerset", "Woodridge", "Newport Hills", "Crossroads", "Bridle Trails"],
    nearby: %w[chimney-services-mercer-island-wa chimney-services-kirkland-wa chimney-services-redmond-wa],
  },
  "chimney-services-mercer-island-wa" => {
    h1: "Mercer Island home care, <em>done with care.</em>",
    lede: "Chimney services and exterior maintenance for Mercer Island homes: sweeping, inspections, masonry repair, gutters, roofs, dryer vents, and pressure washing.",
    homes_h: "Wooded lots, <em>well kept.</em>",
    homes: [
      "Mercer Island's mid-century homes sit on wooded lots, which is part of their appeal and most of their upkeep. Shade keeps roofs damp, moss grows quickly, and needles and leaves fill the gutters.",
      "Many of these homes have large masonry fireplaces, sometimes more than one. A yearly sweep and inspection keeps them safe to use, and catches water damage at the crown and flashing while it's still a small repair.",
    ],
    hoods: ["North End", "Town Center", "First Hill", "East Seattle", "Mercerdale", "South End"],
    nearby: %w[chimney-services-bellevue-wa chimney-services-seattle-wa chimney-services-renton-wa],
  },
  "chimney-services-kirkland-wa" => {
    h1: "Kirkland chimney and home services, <em>handled.</em>",
    lede: "Chimney sweeping, inspections, and repairs, plus gutter, roof, dryer vent, and pressure washing services for Kirkland houses, townhomes, and condos.",
    homes_h: "From lakeside condos <em>to family homes.</em>",
    homes: [
      "Kirkland mixes older single-family neighborhoods with newer townhomes and condos near downtown and Totem Lake. Older homes tend to have masonry chimneys that need sweeping and mortar work. Newer ones often have factory-built fireplaces with metal chase covers that rust.",
      "Townhomes and condos usually have long dryer vent runs that travel through floors and walls before reaching the outside. Those are the vents that clog first, and the ones most worth cleaning every year.",
    ],
    hoods: ["Juanita", "Finn Hill", "Totem Lake", "Rose Hill", "Houghton", "Moss Bay", "Market", "Bridle Trails"],
    nearby: %w[chimney-services-bellevue-wa chimney-services-redmond-wa chimney-services-bothell-wa],
  },
  "chimney-services-redmond-wa" => {
    h1: "Redmond home maintenance <em>for busy households.</em>",
    lede: "Chimney, gutter, roof, dryer vent, and pressure washing services for Redmond homes and townhomes. Book it once and cross it off the list.",
    homes_h: "The upkeep that's easy <em>to put off.</em>",
    homes: [
      "Many Redmond homes were built from the 1970s through the 1990s, often with a factory-built fireplace vented through a wood-framed chase. The metal cover on top of that chase is a common source of leaks once it starts to rust.",
      "Between work and family, gutters and dryer vents are the jobs that slip. We can take care of several in one visit, and send photos when the work is done.",
    ],
    hoods: ["Education Hill", "Downtown Redmond", "Overlake", "Grass Lawn", "Bear Creek", "Idylwood"],
    nearby: %w[chimney-services-kirkland-wa chimney-services-sammamish-wa chimney-services-bellevue-wa],
  },
  "chimney-services-sammamish-wa" => {
    h1: "Sammamish homes, <em>kept in top shape.</em>",
    lede: "Chimney sweeping and inspections, gutter cleaning, moss removal, dryer vent cleaning, and pressure washing for Sammamish family homes.",
    homes_h: "Bigger roofs, <em>more to maintain.</em>",
    homes: [
      "Sammamish is mostly newer two-story homes with steep roofs, long gutter runs, and second-story gutters that are hard to reach safely from a ladder. Surrounded by evergreens, they collect needles all year.",
      "Large driveways, patios, and walkways turn green over a wet winter. A yearly wash, along with a roof and gutter cleaning, keeps the whole exterior looking the way it did when it was new.",
    ],
    hoods: ["Pine Lake", "Klahanie", "Sahalee", "Trossachs", "Plateau", "Beaver Lake"],
    nearby: %w[chimney-services-issaquah-wa chimney-services-redmond-wa chimney-services-bellevue-wa],
  },
  "chimney-services-issaquah-wa" => {
    h1: "Issaquah home care, <em>built for the rain.</em>",
    lede: "Chimney services, gutter cleaning, moss removal, dryer vent cleaning, and pressure washing for Issaquah houses, townhomes, and condos.",
    homes_h: "More rain, more trees, <em>more upkeep.</em>",
    homes: [
      "Tucked against the foothills, Issaquah sees more rain than the cities closer to the Sound, and much of it falls on homes surrounded by forest. Gutters, roofs, and chimneys here work harder than most.",
      "Older homes near Olde Town often have masonry chimneys ready for repointing and new caps, while the Highlands and Talus have newer homes and townhomes where gutters, dryer vents, and exterior washing are the regular jobs.",
    ],
    hoods: ["Olde Town", "Issaquah Highlands", "Talus", "Squak Mountain", "Montreux", "Providence Point"],
    nearby: %w[chimney-services-sammamish-wa chimney-services-bellevue-wa chimney-services-renton-wa],
  },
  "chimney-services-bothell-wa" => {
    h1: "Bothell chimney and home services, <em>one call.</em>",
    lede: "Chimney sweeping, inspections, and repairs, plus gutter, roof, dryer vent, and pressure washing services for Bothell homes on both sides of the county line.",
    homes_h: "Established homes <em>and new neighborhoods.</em>",
    homes: [
      "Bothell sits in both King and Snohomish counties, with established wooded neighborhoods and newer subdivisions around Canyon Park and North Creek. The older homes often have brick fireplaces that haven't been inspected in years.",
      "In the newer neighborhoods, the regular jobs are gutters, dryer vents, and washing the green off driveways and fences after winter.",
    ],
    hoods: ["Downtown Bothell", "Canyon Park", "North Creek", "Thrasher's Corner", "Westhill", "Maywood"],
    nearby: %w[chimney-services-kirkland-wa chimney-services-shoreline-wa chimney-services-redmond-wa],
  },
  "chimney-services-renton-wa" => {
    h1: "Renton chimneys, gutters, and roofs, <em>taken care of.</em>",
    lede: "Chimney services and home maintenance for Renton houses, townhomes, and condos, from the Highlands to Kennydale.",
    homes_h: "Keeping older homes <em>safe and dry.</em>",
    homes: [
      "Renton has many mid-century homes, especially in the Highlands and Kennydale, and most were built with a brick chimney. After decades of weather, crowns crack, mortar wears away, and flashing lets go, which is how water gets in.",
      "A yearly sweep and inspection, with gutters and roof kept clear, is the simplest way to protect an older home from the damage rain does over time.",
    ],
    hoods: ["Renton Highlands", "Kennydale", "Benson Hill", "Fairwood", "Talbot Hill", "The Landing"],
    nearby: %w[chimney-services-mercer-island-wa chimney-services-bellevue-wa chimney-services-issaquah-wa],
  },
  "chimney-services-shoreline-wa" => {
    h1: "Shoreline home care, <em>done right.</em>",
    lede: "Chimney sweeping, inspections, and repairs, plus gutter, roof, dryer vent, and pressure washing services for Shoreline homes, from Richmond Beach to North City.",
    homes_h: "Post-war homes <em>under tall trees.</em>",
    homes: [
      "Much of Shoreline was built in the 1940s through the 1960s, and most of those ramblers have a masonry fireplace. Many have never had a camera inspection, and it's common to find cracked flue tiles and worn mortar.",
      "Shoreline is also known for its big conifers. They shade roofs, feed moss, and drop needles into gutters in every season, so roofs and gutters here need regular attention.",
    ],
    hoods: ["Richmond Beach", "Innis Arden", "Ridgecrest", "Echo Lake", "North City", "Briarcrest"],
    nearby: %w[chimney-services-seattle-wa chimney-services-bothell-wa chimney-services-kirkland-wa],
  },
}

def city_page(area)
  c = CITY_PAGES.fetch(area[:slug])
  city = area[:name]
  cph = %w[sweep-roof fireplace-clean chimney-cap][AREAS.index(area) % 3]
  hoods = c[:hoods].map { |h| "<li>#{h}</li>" }.join
  homes = c[:homes].map { |p| "<p>#{p}</p>" }.join("\n        ")
  nearby = rel_html(c[:nearby].map { |sl| AREAS.find { |x| x[:slug] == sl } })
  faq = [
    ["Do you work in #{city}?", "Yes. #{BRAND} serves homes throughout #{city}, including #{c[:hoods].first(3).join(', ')}, and nearby areas."],
    ["How often should my chimney be swept and inspected?", "At least once a year for inspection, according to the national standard (NFPA 211), with sweeping whenever there is soot or creosote buildup. If you burn wood regularly, plan on a yearly sweep."],
    ["Can you do several services in one visit?", "Often, yes. A chimney sweep, gutter cleaning, and dryer vent cleaning fit well together. Tell us everything you'd like done when you book."],
    ["How do I book?", "Use the <a href=\"book.html\" #{U}>booking form</a> or call us. We'll confirm a day and an arrival window."],
  ]
  title = "Chimney Sweep &amp; Home Maintenance in #{city}, WA"
  meta = "Chimney sweeping, inspections, and repairs, plus gutter cleaning, moss removal, dryer vent cleaning, and pressure washing in #{city}, WA. Serving #{c[:hoods].first(3).join(', ')}, and all of #{city}."

  <<~HTML
    #{head_html(title, meta, area[:slug])}
    <body>

    #{header(area[:slug])}

    <main id="top">

    <!-- HERO -->
    #{hero_open(cph, true)}
      <div class="wrap hero-in">
        <p class="eyebrow">Chimney &amp; home maintenance in #{city}, WA</p>
        <h1 id="h1">#{c[:h1]}</h1>
        <p class="lede">#{c[:lede]}</p>
        <div class="hero-ctas">
          <a href="book.html" class="btn btn-brass">Book a service <span class="ar" aria-hidden="true">→</span></a>
          <a href="tel:" data-tel class="btn btn-line">Call <span data-k="phone">[Phone]</span></a>
        </div>
        <ul class="tags" aria-label="#{city} neighborhoods we serve">#{c[:hoods].first(6).map { |h| "<li>#{h}</li>" }.join}</ul>
      </div>
      <div class="wrap">
        #{creds}
      </div>
    </section>

    #{ONES}

    <!-- LOCAL -->
    <section class="sheet sec" aria-labelledby="homes-t">
      <div class="wrap">
        <div class="about" style="margin-bottom:0">
          <div class="ph">#{img_tag(PHOTOS[cph])}</div>
          <div class="txt">
            <p class="eyebrow">#{city} homes</p>
            <h2 id="homes-t">#{c[:homes_h]}</h2>
            #{homes}
            <div class="hoods"><span class="mono">Neighborhoods we serve in #{city}</span><ul>#{hoods}</ul></div>
          </div>
        </div>
      </div>
    </section>

    <!-- SERVICES -->
    <section class="sheet sec" aria-labelledby="svc-t" style="background:var(--paper-2)">
      <div class="wrap">
        <div class="head">
          <div><p class="eyebrow">Services in #{city}</p><h2 id="svc-t">What we do <em>in #{city}.</em></h2></div>
          <p>Chimney and fireplace work, and the exterior upkeep that keeps a Northwest home dry.</p>
        </div>
        <div class="rel">
          #{rel_html(ALL)}
        </div>
      </div>
    </section>

    <!-- PROCESS -->
    <section class="sheet sec" aria-labelledby="proc-t">
      <div class="wrap">
        <div class="head">
          <div><p class="eyebrow">How it works</p><h2 id="proc-t">A simple visit. <em>No surprises.</em></h2></div>
          <p>Four of the six steps happen before any work begins, so you always know what's being done and why.</p>
        </div>
    #{PROCESS.gsub(/^/, '    ').chomp}
      </div>
    </section>

    <!-- FAQ -->
    <section class="sheet sec" aria-labelledby="faq-t" style="background:var(--paper-2)">
      <div class="wrap">
        <div class="faq">
          <div class="head">
            <div><p class="eyebrow">FAQ</p><h2 id="faq-t">#{city} <em>questions.</em></h2></div>
            <p>Anything else, ask us when you book.</p>
          </div>
          <div>
            #{faq_html(faq)}
          </div>
        </div>
      </div>
    </section>

    <!-- NEARBY -->
    <section class="sheet sec" aria-labelledby="near-t">
      <div class="wrap">
        <div class="head">
          <div><p class="eyebrow">Nearby</p><h2 id="near-t">Also serving <em>nearby.</em></h2></div>
          <p><a href="service-areas.html" #{U}>See all the areas we serve</a>.</p>
        </div>
        <div class="rel">
          #{nearby}
        </div>
      </div>
    </section>

    #{cta_band("Need a hand in #{city}? <em>Let's talk.</em>")}

    </main>

    #{footer}

    #{tail_html}
  HTML
end

def area_cards(n, go)
  AREAS.map { |a|
    %(<a class="area-card" href="#{a[:slug]}.html"><span class="mono">#{CITY_PAGES[a[:slug]][:hoods].first(n).join(' · ')}</span><b>#{a[:name]}</b><span class="go">#{go.(a)} <span aria-hidden="true">→</span></span></a>)
  }.join("\n      ")
end

def areas_hub
  <<~HTML
    #{head_html("Service Areas: #{REGION}", "#{BRAND} serves Seattle, Bellevue, Mercer Island, Kirkland, Redmond, Sammamish, Issaquah, Bothell, Renton, and Shoreline with chimney services and home maintenance.", "service-areas")}
    <body>

    #{header("service-areas")}

    <main id="top">

    <section class="dark page-top" aria-labelledby="h1">
      <div class="wrap">
        <p class="eyebrow">Service areas</p>
        <h1 id="h1">Serving Seattle <em>&amp; the Eastside.</em></h1>
        <p class="lede">We sweep, inspect, and repair chimneys, and clean gutters, roofs, dryer vents, and exteriors in these cities and the neighborhoods around them. Choose your city to learn more.</p>
      </div>
    </section>

    <section class="sheet sec" aria-label="Cities we serve" style="padding-top:clamp(56px,6vw,96px)">
      <div class="wrap">
        <div class="area-grid">
          #{area_cards(3, ->(a) { "Services in #{a[:name]}" })}
        </div>
        <a class="callout" href="book.html">
          <span class="mono">Not on the list?</span>
          <span class="ct">We may still be able to help. <em>Send us a request</em> and tell us where you are.</span>
          <span class="ar" aria-hidden="true">→</span>
        </a>
      </div>
    </section>

    #{cta_band}

    </main>

    #{footer}

    #{tail_html}
  HTML
end

# ================================================================ HOME
HOME_SERVICES = [
  ["chimney-sweep", "Chimney sweeping", "Soot and creosote removed, top to bottom", "The flue, smoke chamber, damper, and firebox cleaned for fireplaces, inserts, and wood and pellet stoves, with floors covered and dust kept under control."],
  ["chimney-inspection", "Chimney inspections", "Yearly checkups and camera inspections", "Yearly inspections, camera inspections for home sales, and checks after a chimney fire, earthquake, or storm, each with a written photo report."],
  ["chimney-repair", "Chimney repair", "Mortar, crowns, flashing, and leaks", "Tuckpointing, brick replacement, crown and flashing repair, waterproofing, firebox repair, and rebuilds from the roofline up."],
  ["chimney-caps-liners", "Caps, dampers &amp; liners", "Keep out rain, animals, and downdrafts", "Chimney caps, chase covers, top-sealing dampers, and stainless steel liners measured for your chimney and installed to stay put."],
  ["fireplace-services", "Fireplaces &amp; stoves", "Fireplaces, inserts, wood and pellet stoves", "Cleaning and service for the appliance itself, and answers for smoky fireplaces, poor draft, and odors."],
  ["gutter-cleaning", "Gutter cleaning", "Cleared by hand, downspouts flushed", "Gutters cleaned out, downspouts flushed, roof debris removed, minor repairs made, and gutter guards installed, with before and after photos."],
  ["roof-cleaning-moss-removal", "Roof cleaning &amp; moss removal", "Moss off, without damaging the roof", "Moss removed with methods suited to your roofing, debris cleared, and a treatment applied to slow it from coming back."],
  ["dryer-vent-cleaning", "Dryer vent cleaning", "The whole run, from dryer to outside wall", "The full vent line brushed and cleared, the outside hood cleaned, and airflow checked before and after."],
  ["air-duct-cleaning", "Air duct cleaning", "Brushed, vacuumed, and checked by camera", "Supply and return ducts cleaned from the registers back to the furnace, with a camera look inside before and after."],
  ["pressure-washing", "Pressure washing", "Driveways, walks, patios, decks, siding", "Moss, algae, and grime washed away with the right pressure for each surface, including soft washing for siding."],
]

def home_page
  rows = HOME_SERVICES.each_with_index.map { |(slug, name, sh, text), i|
    svc = ALL.find { |s| s[:slug] == slug }
    %(<details#{i.zero? ? ' open' : ''}><summary><span class="mono">#{format('%02d', i + 1)}</span>#{name}<span class="sh">#{sh}</span><span class="pm" aria-hidden="true"></span></summary>
            <div class="more"><p>#{text}</p><div class="acts"><a href="#{slug}.html" class="btn btn-line-d">Learn more <span class="ar" aria-hidden="true">→</span></a><a href="#{book_url(svc)}" class="btn btn-brass">Book this <span class="ar" aria-hidden="true">→</span></a></div></div></details>)
  }.join("\n      ")
  hero_tags = [["chimney-sweep", "Chimney sweeping"], ["chimney-inspection", "Inspections"], ["chimney-repair", "Chimney repair"], ["gutter-cleaning", "Gutters"], ["roof-cleaning-moss-removal", "Moss removal"], ["dryer-vent-cleaning", "Dryer vents"], ["pressure-washing", "Pressure washing"]]
    .map { |s, n| %(<li><a class="plain" href="#{s}.html">#{n}</a></li>) }.join
  faq = [
    ["How often should a chimney be swept?", "The national standard, NFPA 211, calls for chimneys, fireplaces, and vents to be inspected at least once a year and cleaned when needed. If you burn wood regularly, plan on a sweep every year. <a href=\"chimney-sweep.html\" #{U}>More about chimney sweeping</a>."],
    ["When is the best time to book chimney work?", "Late spring through early fall. The weather is dry enough for roof and masonry work, and you'll be ready before the first cold night. Fall is the busiest season, so booking early helps."],
    ["How often do gutters need cleaning around Seattle?", "At least twice a year for most homes: in late fall after the leaves drop, and again in spring. Homes under fir, cedar, or maple trees often need a third cleaning."],
    ["Do you pressure wash roofs?", "Not asphalt shingle roofs. High pressure strips the granules that protect the shingles. Moss is removed with gentler methods and then treated. <a href=\"roof-cleaning-moss-removal.html\" #{U}>See how moss removal works</a>."],
    ["Can you do several services in one visit?", "Often, yes. A chimney sweep, gutter cleaning, and dryer vent cleaning fit well together, and it saves you a second appointment. Tell us everything you'd like done when you book."],
    ["Do I need to be home?", "For chimney, fireplace, and dryer vent work, yes, because we need to get inside. For gutters, roofs, and pressure washing, usually not, as long as we can reach the outside of the house and a water spigot."],
    ["Which areas do you serve?", "Seattle, Bellevue, Mercer Island, Kirkland, Redmond, Sammamish, Issaquah, Bothell, Renton, Shoreline, and the neighborhoods around them. <a href=\"service-areas.html\" #{U}>See all service areas</a>."],
  ]
  season = ->(*slugs) { slugs.map { |sl| s = ALL.find { |x| x[:slug] == sl }; %(<li><a href="#{sl}.html">#{s[:name]}</a></li>) }.join }

  <<~HTML
    #{head_html(BRAND, "Chimney sweeping, inspections, and repairs, plus gutter cleaning, roof moss removal, dryer vent cleaning, and pressure washing across Seattle and the Eastside.", "")}
    <body>

    #{header(nil, home: true)}

    <main id="top">

    <!-- HERO -->
    #{hero_open("sweep-roof", false)}
      <div class="wrap hero-in">
        <p class="eyebrow">Chimney &amp; home maintenance · #{REGION}</p>
        <h1 id="h1">Clean chimneys. <em>Cared-for homes.</em></h1>
        <p class="lede">Chimney sweeping, inspections, and repairs, plus gutter cleaning, roof moss removal, dryer vent cleaning, and pressure washing. One call for the upkeep that keeps your home safe, dry, and looking its best.</p>
        <div class="hero-ctas">
          <a href="book.html" class="btn btn-brass">Book a service <span class="ar" aria-hidden="true">→</span></a>
          <a href="#services" class="btn btn-line">See our services</a>
          <a href="tel:" data-tel class="btn btn-line">Call <span data-k="phone">[Phone]</span></a>
        </div>
        <ul class="tags" aria-label="What we do">
          #{hero_tags}
        </ul>
      </div>
      <div class="wrap">
        #{creds}
      </div>
    </section>

    #{ONES}

    <!-- PHOTOS -->
    <section class="sheet sec" id="work" aria-labelledby="work-t">
      <div class="wrap">
        <div class="head">
          <div><p class="eyebrow">A closer look</p><h2 id="work-t">The work, <em>up close.</em></h2></div>
          <p>Chimneys, fireplaces, and ducts: the jobs most homeowners never get to see.</p>
        </div>
      </div>
      <div class="reel">
    #{proj_card("fireplace-clean", 0, cls: " span2", frame: "")}
    #{proj_card("chimney-cap", 1, frame: "")}
    #{proj_card("conv-gas", 2)}
    #{proj_card("conv-electric", 3)}
    #{proj_card("duct-clean", 4)}
      </div>
      <div class="reel-foot"><a href="book.html" class="btn btn-ink">Book a service <span class="ar" aria-hidden="true">→</span></a></div>
    </section>

    <!-- SERVICES -->
    <section class="dark sec" id="services" aria-labelledby="svc-t">
      <div class="wrap">
        <div class="head">
          <div><p class="eyebrow">Services</p><h2 id="svc-t">Everything your home needs, <em>from the chimney down.</em></h2></div>
          <p>Chimney and fireplace work, and the exterior upkeep that keeps a Northwest home dry. Open a service to see what's included, or visit its page for the full details.</p>
        </div>
        <div class="svc-list">
          #{rows}
        </div>
      </div>
    </section>

    <!-- ABOUT + WHY -->
    <section class="sheet sec" id="about" aria-labelledby="about-t">
      <div class="wrap">
        <div class="about">
          <div class="ph">#{img_tag(PHOTOS["fireplace-clean"])}</div>
          <div class="txt">
            <p class="eyebrow">About us</p>
            <h2 id="about-t">Home upkeep, <em>made simple.</em></h2>
            <p class="lead">The jobs that protect a house are the easiest ones to put off: the chimney nobody has looked inside, the gutters that overflowed last winter, the moss creeping across the roof.</p>
            <p>#{BRAND} takes care of them for homeowners across Seattle and the Eastside. We show up when we say we will, protect your home while we work, and show you photos of what we found.</p>
            <p>If something needs repair, you get a clear explanation and a price before anything is done. If it doesn't, we'll tell you that too.</p>
          </div>
        </div>
        <h3 class="why-t">What we take <em>off your list.</em></h3>
        <div class="worries">
          <article class="worry"><div class="idx mono"><span>01</span><span>Chimney</span></div><h3><s>Creosote in the flue</s></h3><p>Sweeping removes the soot and creosote that build up with every fire.</p></article>
          <article class="worry"><div class="idx mono"><span>02</span><span>Leaks</span></div><h3><s>Water in the chimney</s></h3><p>Crowns, caps, flashing, and mortar joints are checked and repaired before a small leak becomes a big one.</p></article>
          <article class="worry"><div class="idx mono"><span>03</span><span>Gutters</span></div><h3><s>Overflowing gutters</s></h3><p>Gutters and downspouts are cleared and flushed, so rainwater runs away from the house.</p></article>
          <article class="worry"><div class="idx mono"><span>04</span><span>Roof</span></div><h3><s>Moss on the roof</s></h3><p>Moss is removed with methods suited to your roofing, then treated to slow its return.</p></article>
          <article class="worry"><div class="idx mono"><span>05</span><span>Dryer</span></div><h3><s>A dryer that takes two cycles</s></h3><p>The vent line is cleared from the dryer to the outside wall, so air moves freely again.</p></article>
          <article class="worry"><div class="idx mono"><span>06</span><span>Exterior</span></div><h3><s>Green, slippery walkways</s></h3><p>Driveways, paths, decks, and patios are washed clean of algae, moss, and grime.</p></article>
        </div>
      </div>
    </section>

    <!-- PROCESS -->
    <section class="sheet sec" id="process" aria-labelledby="proc-t" style="background:var(--paper-2)">
      <div class="wrap">
        <div class="head">
          <div><p class="eyebrow">How it works</p><h2 id="proc-t">A simple visit. <em>No surprises.</em></h2></div>
          <p>Four of the six steps happen before any work begins, so you always know what's being done and why.</p>
        </div>
    #{PROCESS.gsub(/^/, '    ').chomp}
        <div class="track-note">
          <p>Before any repair starts, <em>you've seen the photos and the price.</em></p>
          <a href="book.html" class="btn btn-ink">Book a service <span class="ar" aria-hidden="true">→</span></a>
        </div>
      </div>
    </section>

    <!-- SEASONS -->
    <section class="dark sec" id="seasons" aria-labelledby="season-t">
      <div class="wrap">
        <div class="head">
          <div><p class="eyebrow">Through the year</p><h2 id="season-t">A Northwest home, <em>season by season.</em></h2></div>
          <p>The right job at the right time of year is easier, and it prevents the expensive problems. Here is a simple calendar to work from.</p>
        </div>
        <div class="incl">
          <div><span class="mono when">Spring</span><h3>After the storms</h3><p>Clear what winter left behind and wash away the green.</p><ul>#{season.("gutter-cleaning", "roof-cleaning-moss-removal", "pressure-washing")}</ul></div>
          <div><span class="mono when">Summer</span><h3>Dry-weather work</h3><p>The best time for masonry repairs and anything on the roof.</p><ul>#{season.("chimney-repair", "chimney-caps-liners", "chimney-inspection")}</ul></div>
          <div><span class="mono when">Fall</span><h3>Before the first fire</h3><p>Get the chimney swept and checked before burning season.</p><ul>#{season.("chimney-sweep", "fireplace-services", "dryer-vent-cleaning")}</ul></div>
          <div><span class="mono when">Winter</span><h3>Once the leaves are down</h3><p>Clean the gutters again so winter rain has somewhere to go.</p><ul>#{season.("gutter-cleaning", "chimney-inspection")}</ul></div>
        </div>
      </div>
    </section>

    <!-- FAQ -->
    <section class="sheet sec" id="faq" aria-labelledby="faq-t">
      <div class="wrap">
        <div class="faq">
          <div class="head">
            <div><p class="eyebrow">FAQ</p><h2 id="faq-t">Questions<em>.</em></h2></div>
            <p>Anything else, ask us when you book.</p>
          </div>
          <div>
            #{faq_html(faq)}
          </div>
        </div>
      </div>
    </section>

    <!-- AREAS -->
    <section class="sheet sec" id="areas" aria-labelledby="areas-t" style="background:var(--paper-2)">
      <div class="wrap">
        <div class="head">
          <div><p class="eyebrow">Service areas</p><h2 id="areas-t">Proudly serving <em>#{REGION}.</em></h2></div>
          <p>We serve homeowners in these cities and the neighborhoods around them. <a href="service-areas.html" #{U}>See all service areas</a>.</p>
        </div>
        <div class="area-grid">
          #{area_cards(2, ->(_) { "View" })}
        </div>
      </div>
    </section>

    #{cta_band("Ready to cross it <em>off the list?</em>")}

    <!-- CONTACT -->
    <section class="dark sec contact" id="contact" aria-labelledby="contact-t">
      <div class="wrap">
        <div class="grid">
          <div>
            <p class="eyebrow">Contact</p>
            <h2 id="contact-t">Tell us what <em>your home needs.</em></h2>
            <p class="intro">A chimney that's overdue, gutters that overflow, a roof going green. Send us the details and we'll set up a visit.</p>
            <div class="hero-ctas">
              <a href="book.html" class="btn btn-brass">Book a service <span class="ar" aria-hidden="true">→</span></a>
              <a href="tel:" data-tel class="btn btn-line">Call <span data-k="phone">[Phone]</span></a>
            </div>
          </div>
          <div>
            <div class="cards" style="margin-top:0">
              <div class="card"><span class="mono">Phone <button type="button" class="copy" data-copy="phone">Copy</button></span><a class="v" href="tel:" data-tel data-k="phone">[Phone]</a></div>
              <div class="card"><span class="mono">Email <button type="button" class="copy" data-copy="email">Copy</button></span><a class="v" href="book.html" data-mail data-k="email">[Email]</a></div>
              <div class="card"><span class="mono">Hours</span><span class="v" data-k="hours">[Business hours]</span></div>
              <div class="card"><span class="mono">Location</span><span class="v" data-k="address">[Address]</span></div>
            </div>
            <div class="areas">
              <span class="mono">Areas we serve</span>
              <ul>#{AREAS.map { |a| %(<li><a href="#{a[:slug]}.html">#{a[:name]}</a></li>) }.join}</ul>
            </div>
          </div>
        </div>
      </div>
    </section>

    </main>

    #{footer}

    #{tail_html}
  HTML
end

# ================================================================ BOOKING
def book_page
  chips = (ALL.map { |s| s[:chip] } + ["Not sure yet"]).map { |c| %(<label class="chip"><input type="checkbox" name="services" value="#{c}"><span>#{c}</span></label>) }.join
  <<~HTML
    #{head_html("Book a Service", "Request chimney sweeping, inspection, or repair, gutter cleaning, moss removal, dryer vent cleaning, or pressure washing from #{BRAND} in Seattle and the Eastside.", "book")}
    <body>

    #{header("book")}

    <main id="top">

    <section class="dark page-top" aria-labelledby="h1">
      <div class="wrap">
        <p class="eyebrow">Book a service</p>
        <h1 id="h1">Tell us what <em>your home needs.</em></h1>
        <p class="lede">Chimneys, gutters, roofs, dryer vents, and exteriors across Seattle and the Eastside. Send us the details, and we'll get back to you to confirm a time.</p>
      </div>
    </section>

    <section class="sheet sec" style="padding-top:clamp(56px,6vw,96px)" aria-label="Service request">
      <div class="wrap">
        <div class="consult">
          <div class="side">
            <h2 class="why-t">What happens <em>next.</em></h2>
            <ol class="steps">
              <li><span class="no">1</span><div><h3>We reach out</h3><p>We contact you to confirm the details and answer any questions.</p></div></li>
              <li><span class="no">2</span><div><h3>We set a time</h3><p>You get a day and an arrival window that works for you.</p></div></li>
              <li><span class="no">3</span><div><h3>We do the work</h3><p>We look first, show you what we find, and price any repair before it starts.</p></div></li>
            </ol>
            <div class="reach">
              <div><span class="mono">Prefer to call?</span><a href="tel:" data-tel data-k="phone">[Phone]</a></div>
              <div><span class="mono">Email</span><a href="book.html" data-mail data-k="email">[Email]</a></div>
              <div><span class="mono">Hours</span><span data-k="hours">[Business hours]</span></div>
              <div><span class="mono">License</span><span>WA <span data-k="license">[License #]</span> · <span data-k="insurance">[Insurance details]</span></span></div>
            </div>
          </div>

          <form id="book-form" novalidate>
            <div class="fields">
              <div class="ftitle"><b>Request a service</b></div>
              <div class="field"><label for="f-name">Name</label><input id="f-name" name="name" autocomplete="name" required></div>
              <div class="field"><label for="f-phone">Phone</label><input id="f-phone" name="phone" type="tel" autocomplete="tel" required></div>
              <div class="field"><label for="f-email">Email (optional)</label><input id="f-email" name="email" type="email" autocomplete="email"></div>
              <div class="field"><label for="f-address">Home address or city</label><input id="f-address" name="address" autocomplete="street-address"></div>
              <fieldset class="full"><legend class="legend">What do you need?</legend><div class="chips">#{chips}</div></fieldset>
              <div class="field full"><label for="f-message">Anything we should know?</label><textarea id="f-message" name="message" rows="4" placeholder="For example: two-story house, wood stove in the basement, last swept three years ago."></textarea></div>
              <div class="ffoot"><span class="err" role="alert"></span><button type="submit" class="btn btn-ink">Send request <span class="ar" aria-hidden="true">→</span></button></div>
            </div>
            <div class="done" hidden>
              <h3></h3>
              <p></p>
              <pre></pre>
              <button type="button" class="copy">Copy details</button>
            </div>
          </form>
        </div>
      </div>
    </section>

    </main>

    #{footer}

    #{tail_html(one: true)}
  HTML
end

NOT_FOUND = <<~HTML
  <!DOCTYPE html>
  <html lang="en">
  <head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Page not found · #{BRAND}</title>
  <link rel="icon" type="image/png" href="/assets/favicon.png">
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,500;1,500&family=Geist:wght@400;500&display=swap" rel="stylesheet">
  <style>
  :root{--night:#0e0d0b;--paper:#f7f4ee;--gold:#f1bd2c;--muted:#a7a093;color-scheme:dark}
  html,body{height:100%;margin:0}
  body{background:var(--night);color:var(--paper);font:400 17px/1.6 "Geist",system-ui,sans-serif;display:grid;place-items:center;padding:24px;text-align:center}
  .mono{font:500 11.5px "Geist",system-ui,sans-serif;letter-spacing:.18em;text-transform:uppercase;color:var(--gold)}
  h1{font:500 clamp(56px,11vw,140px)/.95 "Cormorant Garamond",Georgia,serif;letter-spacing:-.015em;margin:20px 0}
  h1 em{color:var(--gold)}
  p{color:var(--muted);max-width:28em;margin:0 auto 36px}
  a.btn{display:inline-flex;gap:12px;align-items:center;background:var(--gold);color:var(--night);text-decoration:none;font:500 13px/1 "Geist",system-ui,sans-serif;letter-spacing:.14em;text-transform:uppercase;padding:19px 30px;border-radius:2px}
  a.btn:hover{background:#ffd04f}
  a:focus-visible{outline:2px solid var(--gold);outline-offset:4px}
  </style>
  </head>
  <body>
  <main>
    <p class="mono">Page not found · 404</p>
    <h1>Nothing up <em>this chimney.</em></h1>
    <p>The page you're looking for doesn't exist or has moved.</p>
    <a class="btn" href="/">Back to the homepage →</a>
  </main>
  </body>
  </html>
HTML

# ================================================================ write files
w = ->(name, body) { File.write(File.join(ROOT, name), body) }
w.("index.html", home_page)
w.("book.html", book_page)
w.("service-areas.html", areas_hub)
w.("404.html", NOT_FOUND)
PAGES.each { |pg| w.("#{pg[:slug]}.html", page(pg)) }
AREAS.each { |a| w.("#{a[:slug]}.html", city_page(a)) }
puts "built home, booking, #{PAGES.size} service pages, #{AREAS.size} city pages, service-areas.html, and 404.html"

if SITE_URL.empty?
  w.("robots.txt", "User-agent: *\nAllow: /\n")
  puts "SITE_URL is blank: sitemap.xml not written yet"
else
  urls = ["", "book"] + ALL.map { |s| s[:slug] } + ["service-areas"] + AREAS.map { |a| a[:slug] }
  w.("sitemap.xml", %(<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n) +
    urls.map { |u| "  <url><loc>#{SITE_URL}/#{u}</loc></url>" }.join("\n") + "\n</urlset>\n")
  w.("robots.txt", "User-agent: *\nAllow: /\n\nSitemap: #{SITE_URL}/sitemap.xml\n")
  puts "wrote sitemap.xml (#{urls.size} pages)"
end
