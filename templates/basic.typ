#import "../libs/basic-resume/basic-resume.typ": *
#import "../libs/basic-resume/utils.typ": strip-url, find-profile

#let data = json("../resume.json")

// Extract github and linkedin urls if provided
#let github-profile = find-profile(data.basics.profiles, network: "github")
#let github = if github-profile == none { "" } else { github-profile.url }

#let linkedin-profile = find-profile(data.basics.profiles, network: "linkedin")
#let linkedin = if linkedin-profile == none { "" } else { linkedin-profile.url }

#show: resume.with(
  accent-color: color.blue.darken(40%),
  author-position: center,
  author: data.basics.name,
  email: data.basics.email,
  font: "New Computer Modern",
  github: strip-url(url: github),
  linkedin: strip-url(url: linkedin),
  location: data.basics.location.address,
  paper: "a4",
  personal-info-position: center,
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

== Work Experience

#for w in data.work [

  #work(
    company: w.position,
    dates: dates-helper(start-date: w.startDate, end-date: w.at("endDate", default: "Present")),
    location: w.at("location", default: ""),
    title: w.name,
  )
  #for i in w.highlights [
    - #i
  ]
]

== Projects

#for p in data.projects [

  #project(
    name: p.name,
  )
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

  #edu(
    consistent: true,
    dates: dates-helper(start-date: e.startDate, end-date: e.at("endDate", default: "Present")),
    degree: [#e.studyType | #e.area],
    gpa: e.score,
    institution: e.institution,
    location: e.at("location", default: ""),
  )
]
