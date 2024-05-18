# style_panelset_tabs

    Code
      style_panelset_tabs(foreground = "var(--text-mild)", background = "unset",
        active_foreground = "var(--text-dark)", active_background = "var(--text-lightest)",
        active_border_color = "var(--purple)", hover_background = "#fafafa",
        hover_border_color = "var(--text-lightest)", inactive_opacity = 1,
        separator_color = "var(--text-mild)")
    Output
      <style>:root{--panel-tab-foreground:var(--text-mild);--panel-tab-background:unset;--panel-tab-active-foreground:var(--text-dark);--panel-tab-active-background:var(--text-lightest);--panel-tab-active-border-color:var(--purple);--panel-tab-hover-background:#fafafa;--panel-tab-hover-border-color:var(--text-lightest);--panel-tabs-separator-color:var(--text-mild);--panel-tab-inactive-opacity:1;}</style>

---

    Code
      style_panelset_tabs(foreground = "var(--text-mild)", background = "unset",
        active_foreground = "var(--text-dark)", active_background = "var(--text-lightest)",
        active_border_color = "var(--purple)", hover_background = "#fafafa",
        hover_border_color = "var(--text-lightest)", inactive_opacity = 1,
        separator_color = "var(--text-mild)", selector = NULL)
    Output
      --panel-tab-foreground:var(--text-mild);--panel-tab-background:unset;--panel-tab-active-foreground:var(--text-dark);--panel-tab-active-background:var(--text-lightest);--panel-tab-active-border-color:var(--purple);--panel-tab-hover-background:#fafafa;--panel-tab-hover-border-color:var(--text-lightest);--panel-tabs-separator-color:var(--text-mild);--panel-tab-inactive-opacity:1;

# panelset knitr chunks with plots

    Code
      cat(render_slide_text(paste("```{r echo=FALSE}",
        "xaringanExtra::use_panelset(in_xaringan = TRUE)", "```", "",
        "```{r plot, panelset = TRUE}", "hist(precip)", "```", sep = "\n")))
    Output
      .panel[.panel-name[Code]
      
      ``` r
      hist(precip)
      ```
      
      ]
      
      .panel[.panel-name[Output]
      
      ![](slides_files/figure-html/plot-1.png)&lt;!-- --&gt;
      
      ]

# panelset knitr chunks with custom tab names

    Code
      cat(render_slide_text(paste("```{r echo=FALSE}",
        "xaringanExtra::use_panelset(in_xaringan = TRUE)", "```", "",
        "```{r plot, panelset = c(source = 'Hist', output = 'Plot')}", "hist(precip)",
        "```", sep = "\n")))
    Output
      .panel[.panel-name[Hist]
      
      ``` r
      hist(precip)
      ```
      
      ]
      
      .panel[.panel-name[Plot]
      
      ![](slides_files/figure-html/plot-1.png)&lt;!-- --&gt;
      
      ]

# panelset knitr chunks with mutiple outputs

    Code
      cat(render_slide_text(paste("```{r echo=FALSE}",
        "xaringanExtra::use_panelset(in_xaringan = TRUE)", "```", "",
        "```{r panelset = TRUE}", "print(\"Oak is strong and also gives shade.\")",
        "print(\"The lake sparkled in the red hot sun.\")", "```", sep = "\n")))
    Output
      .panel[.panel-name[Code]
      
      ``` r
      print("Oak is strong and also gives shade.")
      print("The lake sparkled in the red hot sun.")
      ```
      
      ]
      
      .panel[.panel-name[Output]
      
      ```
      ## [1] "Oak is strong and also gives shade."
      ## [1] "The lake sparkled in the red hot sun."
      ```
      
      ]

