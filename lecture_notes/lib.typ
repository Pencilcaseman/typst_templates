// Packages
#import "@preview/cetz:0.4.2" as cetz
#import "@preview/codly-languages:0.1.8": *
#import "@preview/codly:1.3.0": *
#import "@preview/lilaq:0.5.0" as lq
#import "@preview/mannot:0.3.0": *
#import "@preview/physica:0.9.6": *
#import "@preview/showybox:2.0.4" as showybox

#let lecture_notes(
  module: none,
  course: none,
  author: none,
  university: none,
  paper-size: "a4",
  show-outline: true,
  bibliography: none,
  figure-supplement: [Fig.],
  for-print: false,
  // The paper's content.
  body,
) = {
  // Main document configuration
  set document(title: [#university #course #module], author: author)

  // Font config
  // set text(font: "STIX Two Text", size: 10pt, spacing: .35em)
  // set text(font: "New Computer Modern", size: 10pt, spacing: .35em)
  set text(size: 10pt, spacing: .35em)

  // Enumeration numbering
  set enum(numbering: "1. a. i.")

  // Tables & figures
  show figure: set block(spacing: 15.5pt)
  show figure: set place(clearance: 15.5pt)
  show figure.where(kind: table): set figure.caption(
    position: top,
    separator: [\ ],
  )
  show figure.where(kind: table): set text(size: 8pt)
  show figure.where(kind: table): set figure(numbering: "I")
  show figure.where(kind: image): set figure(
    supplement: figure-supplement,
    numbering: "1",
  )
  show figure.caption: set text(size: 8pt)
  show figure.caption: set align(center)
  show figure.caption.where(kind: table): set align(center)

  set figure(scope: "parent", placement: top)

  // Adapt supplement in caption independently from supplement used for
  // references.
  set figure.caption(separator: [. ])
  show figure: fig => {
    let prefix = (
      if fig.kind == table [TABLE] else if fig.kind
        == image [Fig.] else [#fig.supplement]
    )
    let numbers = numbering(fig.numbering, ..fig.counter.at(fig.location()))
    // Wrap figure captions in block to prevent the creation of paragraphs. In
    // particular, this means `par.first-line-indent` does not apply.
    // See https://github.com/typst/templates/pull/73#discussion_r2112947947.
    show figure.caption: it => block[#prefix~#numbers#it.separator#it.body]
    show figure.caption.where(kind: table): smallcaps
    fig
  }

  // Code blocks
  show raw: set text(
    font: "Monaspace Neon",
    ligatures: true,
    size: 1em,
    spacing: 100%,
  )

  // Configure the page and multi-column properties.
  set columns(gutter: 12pt)
  set page(
    numbering: none,
    footer: none,
    columns: 2,
    paper: paper-size,
    // The margins depend on the paper size.
    margin: if paper-size == "a4" {
      (x: 1.25cm, top: 2.5cm, bottom: 1.5cm)
    } else {
      (
        x: (50pt / 216mm) * 100%,
        top: (55pt / 279mm) * 100%,
        bottom: (64pt / 279mm) * 100%,
      )
    },
  )

  // Configure equation numbering and spacing.
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 0.65em)

  // Configure lists.
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)

  // Configure headings.
  set heading(numbering: "I.A.a)")
  show heading: it => {
    set text(10pt, weight: 400)

    let level = counter(heading).get()
    let last_level = if level != () {
      level.last()
    } else {
      1
    }

    if it.level == 1 {
      let exclude = (
        it.body
          in (
            [Acknowledgment],
            [Acknowledgement],
            [Acknowledgments],
            [Acknowledgements],
          )
      )

      set align(center)
      set text(if exclude { 10pt } else { 14pt })
      show: block.with(above: 15pt, below: 13.75pt, sticky: true)
      show: smallcaps

      if it.numbering != none and not exclude {
        numbering("I.", last_level)
        h(7pt, weak: true)
      }

      it.body
    } else if it.level == 2 {
      // Second-level headings are run-ins.
      set align(center)
      set text(size: 12pt)
      show: block.with(spacing: 12pt, sticky: true)
      show: smallcaps

      if it.numbering != none {
        numbering("1.", last_level)
        h(7pt, weak: true)
      }

      it.body
    } else if it.level == 3 {
      set align(center)
      set text(size: 11pt)
      show: smallcaps
      numbering("A.", last_level)
      h(7pt, weak: true)

      it.body
    } else {
      set align(left)
      set text(size: 10pt)
      show: smallcaps

      block[
        #numbering("I.I.I.I.I.I.I)", ..level.slice(3))
        #h(7pt, weak: true)
        #it.body
      ]
    }
  }

  // Style bibliography.
  show std.bibliography: set text(8pt)
  show std.bibliography: set block(spacing: 0.5em)
  set std.bibliography(title: text(10pt)[References], style: "ieee")

  show: codly-init.with()
  codly(languages: codly-languages)

  // Display authors on the title page. We want to span the whole page, hence
  // the float at the parent scope
  place(
    top,
    float: true,
    scope: "parent",
    clearance: 30pt,
    {
      v(4cm)

      line(
        angle: 0rad,
        length: 100%,
        stroke: stroke(thickness: 0.4mm),
      )

      // Module
      {
        set align(center)
        set text(size: 32pt)
        block(above: 15mm, below: 8mm, module)
      }

      // Course
      {
        set align(center)
        set text(size: 24pt)
        block(below: 15mm, course)
      }

      line(
        angle: 0rad,
        length: 100%,
        stroke: stroke(thickness: 0.4mm),
      )

      v(0.4fr)

      // Author and University
      {
        set align(center)
        set text(size: 16pt)

        text(author, size: 16pt)
        linebreak()

        text(university, size: 14pt, style: "italic")
      }

      v(0.05fr)

      // Compilation date
      {
        set align(center)
        set text(size: 14pt)
        text(datetime.today().display("[day] [month repr:long] [year]"))
      }

      v(4cm)
    },
  )

  set par(
    justify: true,
    first-line-indent: (amount: 1em, all: false),
    spacing: 0.75em,
    leading: 0.5em,
  )

  pagebreak(to: if for-print { "odd" } else { none })

  if show-outline {
    set page(
      columns: 1,
    )

    show text: text.with(size: 1.15em)

    show outline.entry: it => {
      let gap = if it.level < 3 {
        (1em, 0.5em, 0.25em).at(it.level)
      } else {
        0.5em
      }

      v(gap)
      it
    }

    outline(indent: 2em)

    pagebreak(to: if for-print { "odd" } else { none })
  }

  counter(page).update(1)
  set page(
    numbering: "1",
    header: context {
      set text(style: "italic")
      [ #course \~ #module ]

      h(1fr)

      set text(style: "normal")
      counter(page).display(
        "1 of 1",
        both: true,
      )

      v(0.25em)

      line(length: 100%, stroke: stroke(thickness: 0.5pt))
    },
  )

  // Display the paper's contents.
  body

  // Display bibliography.
  bibliography
}

#let eq_no_num(body) = {
  math.equation(block: true, numbering: none, body)
}

#let colored_titlebox(title: [Definition], footer: "", color: color, body) = {
  h(5mm)

  if title == none {
    showybox.showybox(
      frame: (
        body-color: color.lighten(90%),
        footer-color: color.lighten(75%),
        border-color: color.darken(50%),
        radius: (rest: 1mm),
      ),
      footer: if footer == "" { "" } else {
        text(
          emph(footer),
        )
      },
      body,
    )
  } else {
    showybox.showybox(
      title-style: (
        boxed-style: (
          anchor: (
            x: left,
            y: horizon,
          ),
          radius: (rest: 1mm),
        ),
      ),
      frame: (
        title-color: color.darken(50%),
        body-color: color.lighten(90%),
        footer-color: color.lighten(75%),
        border-color: color.darken(50%),
        radius: (rest: 1mm),
      ),
      title: title,
      footer: if footer == "" { "" } else {
        text(
          emph(footer),
        )
      },
      body,
    )
  }
}

#let definition(title: [Definition], footer: "", body) = {
  colored_titlebox(title: title, footer: footer, color: color.green, body)
}

#let theorem(title: [Theorem], footer: "", body) = {
  colored_titlebox(title: title, footer: footer, color: color.purple, body)
}

#let proof(title: [Proof], footer: "", body) = {
  colored_titlebox(title: title, footer: footer, color: color.blue, body)
}

#let note(title: [Note], footer: "", body) = {
  colored_titlebox(title: title, footer: footer, color: color.eastern, body)
}
