list:
    just --list

build template:
    typst compile \
        ./{{ template }}/template/main.typ \
        --root ./{{ template }} \
        --pdf-standard 2.0

lecture-notes: (build "lecture_notes")

simple-report: (build "simple_report")

all: lecture-notes simple-report
