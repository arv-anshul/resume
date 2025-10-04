#import "../libs/basic-resume.typ": *
#import "../libs/utils.typ": strip-url, find-profile

#let data = json("../resume.json")

// Extract github and linkedin urls if provided
#let github-profile = find-profile(data.basics.profiles, network: "github")
#let github = if github-profile == none { "" } else { github-profile.url }

#let linkedin-profile = find-profile(data.basics.profiles, network: "linkedin")
#let linkedin = if linkedin-profile == none { "" } else { linkedin-profile.url }

#show: resume.with(
  accent-color: color.blue.darken(40%),
  author-position: left,
  author: data.basics.name,
  label: data.basics.label,
  email: data.basics.email,
  font: "Inter",
  github: strip-url(url: github),
  linkedin: strip-url(url: linkedin),
  location: data.basics.location.address,
  paper: "a4",
  personal-info-position: left,
  personal-site: strip-url(url: data.basics.at("url", default: "")),
  phone: data.basics.at("phone", default: ""),
)

#set document(
  author: data.basics.name,
  date: datetime.today(),
  description: [
    Resume of #data.basics.name for #data.basics.label role.
    Resume is updated by #datetime.today().display().
  ],
  keywords: ("resume", "cv", "curriculum vitae", "professional resume", lower(data.basics.label)),
  title: [Resume of #data.basics.name for #data.basics.label role],
)

// Capital case for section titles
#show heading.where(level: 2): it => [
  #set text(size: 13pt)
  #pad(top: 0pt, bottom: -10pt, [#upper(it.body)])
  #line(length: 100%, stroke: 1pt + color.blue.darken(40%))
]

#let left-side = [
  == Work Experience

  #for w in data.work [

    #generic-two-by-two(
      top-left: strong(w.name),
      top-right: dates-helper(start-date: w.startDate, end-date: w.at("endDate", default: "Present")),
      bottom-left: emph(text(black.lighten(30%))[#w.position]),
      bottom-right: emph(w.at("location", default: "")),
    )

    #set list(marker: text(black.lighten(30%))[•])
    #for i in w.highlights [
      - #text(black.lighten(30%))[#i]
    ]
  ]

  == Projects

  #for p in data.projects [

    #strong(p.name) #h(1fr) #link(p.url)[Link]
    #linebreak() #emph(text(black.lighten(30%))[#p.description])

    #set list(marker: text(black.lighten(30%))[•])
    #for i in p.highlights [
      - #text(black.lighten(30%))[#i]
    ]
  ]
]

#let right-side = [
  == Skills

  #for s in data.skills [
    #s.keywords.sorted(key: it => it.len()).map((kw) => {
      box(baseline: 6pt)[#rect(stroke: 0.2pt, radius: 20%)[#kw]]
    }).join(" ")
  ]

  == Education

  #for e in data.education [

    #generic-two-by-two(
      top-left: strong(e.institution),
      top-right: emph(e.studyType),
      bottom-left: e.at("endDate", default: ""),
      bottom-right: emph(e.score),
    )
  ]

  == Languages

  #data.languages.map((l) => {
    box(baseline: 6pt)[#rect(stroke: 0.2pt, radius: 20%)[#strong(l.language)]]
    [#h(1fr) #emph([(#l.fluency)])]
  }).join("\n")

  == Certificates

  #for c in data.certificates [

    #generic-two-by-two(
      top-left: [#strong(c.name), #c.issuer],
      top-right: c.date,
      bottom-left: emph(c.summary),
    )
  ]
]

#grid(
  columns: (2fr, 1fr),
  column-gutter: 2em,
  left-side,
  right-side,
)
