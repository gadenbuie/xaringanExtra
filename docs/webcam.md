## 🤳 Webcam

#### 📺 [Webcam Demo](https://pkg.garrickadenbuie.com/xaringanExtra/webcam/)

Add a live video of your webcam into your slides (in your own browser
only). Useful when you are presenting via video conference to include
your video, or when you are recording a class or lecture.

To add **webcam** to your xaringan presentation, add the following code
chunk to your slides’ R Markdown file.

```` markdown
```{r}
xaringanExtra::use_webcam()
```
````

Inside your slides, press **w** to turn the webcam on and off, or press
**Shift** + **W** to move the video to the next corner. You can also
drag and drop the video within the browser window.

The webcam extension is based on the original [webcam
implementation](https://yihui.org/en/2017/12/html5-camera/) by Yihui
Xie, author of [xaringan](https://slides.yihui.org/xaringan).

