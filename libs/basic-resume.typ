// Copy of https://typst.app/universe/package/basic-resume (v0.2.8) project.
// Did some modification in basic-resume.

#import "@preview/scienceicons:0.1.0": github-icon, linkedin-icon, website-icon, email-icon

#let resume(
  author: "",
  author-position: left,
  personal-info-position: left,
  pronouns: "",
  label: "",
  location: "",
  email: "",
  github: "",
  linkedin: "",
  phone: "",
  personal-site: "",
  accent-color: "#000000",
  font: "New Computer Modern",
  paper: "us-letter",
  author-font-size: 20pt,
  font-size: 10pt,
  body,
) = {

  // Sets document metadata
  set document(author: author, title: author)

  // Document-wide formatting, including font and margins
  set text(
    // LaTeX style font
    font: font,
    size: font-size,
    lang: "en",
    // Disable ligatures so ATS systems do not get confused when parsing fonts.
    ligatures: false
  )

  // Reccomended to have 0.5in margin on all sides
  set page(
    margin: (0.5in),
    paper: paper,
  )

  // Link styles
  show link: underline


  // Small caps for section titles
  show heading.where(level: 2): it => [
    #pad(top: 0pt, bottom: -10pt, [#smallcaps(it.body)])
    #line(length: 100%, stroke: 1pt)
  ]

  // Accent Color Styling
  show heading: set text(
    fill: rgb(accent-color),
  )

  show link: set text(
    fill: rgb(accent-color),
  )

  // Name will be aligned left, bold and big
  show heading.where(level: 1): it => [
    #set align(author-position)
    #set text(
      weight: 700,
      size: author-font-size,
    )
    #pad(it.body)
  ]

  // Level 1 Heading
  [= #(author)]

  // Personal Info Helper
  let contact-item(value, icon: "", link-type: "") = {
    if value != "" {
      if link-type != "" {
        [#icon #link(link-type + value)[#value]]
      } else {
        value
      }
    }
  }

  // Personal Info
  pad(
    top: 0.25em,
    align(personal-info-position)[
      #{
        let items = (
          contact-item(label),
          contact-item(pronouns),
          contact-item(phone),
          contact-item(location),
          contact-item(email, icon: email-icon(baseline: 30%, color: accent-color), link-type: "mailto:"),
          contact-item(github, icon: github-icon(baseline: 20%, color: accent-color), link-type: "https://"),
          contact-item(linkedin, icon: linkedin-icon(baseline: 20%, color: accent-color), link-type: "https://"),
          contact-item(personal-site, icon: website-icon(baseline: 25%, color: accent-color), link-type: "https://"),
        )
        items.filter(x => x != none).join(strong(" | "))
      }
    ],
  )

  // Main body.
  set par(justify: true)

  body
}

// Generic two by two component for resume
#let generic-two-by-two(
  top-left: "",
  top-right: "",
  bottom-left: "",
  bottom-right: "",
) = {
  [
    #top-left #h(1fr) #top-right \
    #bottom-left #h(1fr) #bottom-right
  ]
}

// Generic one by two component for resume
#let generic-one-by-two(
  left: "",
  right: "",
) = {
  [
    #left #h(1fr) #right
  ]
}

// Cannot just use normal --- ligature becuase ligatures are disabled for good reasons
#let dates-helper(
  start-date: "",
  end-date: "",
) = {
  [#start-date $dash.en$ #end-date]
}
