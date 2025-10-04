#import "../libs/basic-resume.typ": *
#import "../libs/utils.typ": strip-url, find-profile

#let data = json("../resume.json")

// Extract github and linkedin urls if provided
#let github-profile = find-profile(data.basics.profiles, network: "github")
#let github = if github-profile == none { "" } else { github-profile.username }

#let linkedin-profile = find-profile(data.basics.profiles, network: "linkedin")
#let linkedin = if linkedin-profile == none { "" } else { linkedin-profile.username }

#show: setup-resume.with(
  accent-color: color.blue.darken(40%),
  author: data.basics.name,
  font: "New Computer Modern",
  paper: "a4",
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

// Name on top of the page
= #align(center)[#upper(data.basics.name)]

// Personal info below Name
#personal-info(
  accent-color: color.black,
  email: data.basics.email,
  github: github,
  label: data.basics.label,
  linkedin: linkedin,
  location: data.basics.location.address,
  personal-info-position: center,
  personal-site: strip-url(url: data.basics.at("url", default: "")),
  phone: data.basics.at("phone", default: ""),
)

== Work Experience

#for w in data.work [

  #generic-two-by-two(
    top-left: strong(w.name),
    top-right: dates-helper(start-date: w.startDate, end-date: w.at("endDate", default: "Present")),
    bottom-left: w.position,
    bottom-right: emph(w.at("location", default: "")),
  )

  #for i in w.highlights [
    - #i
  ]
]

== Projects

#for p in data.projects [

  #strong(p.name) #h(1fr) #emph(p.description) #sym.dash.en #link(p.url)[Link]
  #for i in p.highlights [
    - #i
  ]
]

== Skills

#for s in data.skills [
  *#s.name:* #s.keywords.join(", ")
  #linebreak()
]
*Languages:* #data.languages.map((l) => {
  [#l.language (#l.fluency)]
}).join(", ")

== Education

#for e in data.education [

  #generic-two-by-two(
    top-left: strong(e.institution),
    top-right: dates-helper(start-date: e.startDate, end-date: e.at("endDate", default: "Present")),
    bottom-left: emph([#e.studyType | #e.area]),
    bottom-right: emph(e.score),
  )
]

== Certificates

#for c in data.certificates [

  #generic-two-by-two(
    top-left: [#strong(c.name), #c.issuer],
    top-right: c.date,
    bottom-left: emph(c.summary),
  )
]
