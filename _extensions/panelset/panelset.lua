if quarto.doc.hasBootstrap() or quarto.doc.isFormat("revealjs") then
  quarto.doc.addHtmlDependency({
    name = "panelset",
    version = "0.2.7",
    scripts = {"panelset.js"},
    stylesheets = {"panelset.css"}
  })
end
