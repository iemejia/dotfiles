$pdflatex = 'pdflatex -interaction=nonstopmode -synctex=1 %O %S';
if ($^O eq 'darwin') {
    $pdf_previewer = 'open -a skim';
} else {
    $pdf_previewer = 'xdg-open';
}
$clean_ext = 'bbl rel %R-blx.bib %R.synctex.gz';
