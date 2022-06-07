## 🔊 Slide Tone

#### 📺 [Slide Tone Demo](https://pkg.garrickadenbuie.com/xaringanExtra/slide-tone/)

Slide tone plays a subtle sound when you change slides. It was
[requested by a blind R
user](https://github.com/yihui/xaringan/issues/214) and enables users to
hear an auditory signal of their progress through the slides.

The tones increase in pitch for each slide from a low C to a high C
note. The tone pitch stays the same for incremental slides.

Visit the [slide tone demo
slides](https://pkg.garrickadenbuie.com/xaringanExtra/slide-tone/) to
experience it yourself. Or include slide tone in your next xaringan
presentation by adding the following code chunk to your slides’ R
Markdown.

```` markdown
```{r xaringan-slide-tone, echo=FALSE}
xaringanExtra::use_slide_tone()
```
````

