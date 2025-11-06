list:
    just --list

lecture-notes:
    typst compile \
        ./lecture_notes/template/main.typ \
        --root ./lecture_notes \
        --pdf-standard 2.0

all: lecture-notes
