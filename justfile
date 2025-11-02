list:
    just --list

lecture-notes:
    typst compile ./lecture_notes/template/main.typ --root ./lecture_notes

all: lecture-notes
