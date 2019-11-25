(function(f){if(typeof exports==="object"&&typeof module!=="undefined"){module.exports=f()}else if(typeof define==="function"&&define.amd){define([],f)}else{var g;if(typeof window!=="undefined"){g=window}else if(typeof global!=="undefined"){g=global}else if(typeof self!=="undefined"){g=self}else{g=this}g.TextPoster = f()}})(function(){var define,module,exports;return (function(){function r(e,n,t){function o(i,f){if(!n[i]){if(!e[i]){var c="function"==typeof require&&require;if(!f&&c)return c(i,!0);if(u)return u(i,!0);var a=new Error("Cannot find module '"+i+"'");throw a.code="MODULE_NOT_FOUND",a}var p=n[i]={exports:{}};e[i][0].call(p.exports,function(r){var n=e[i][1][r];return o(n||r)},p,p.exports,r,e,n,t)}return n[i].exports}for(var u="function"==typeof require&&require,i=0;i<t.length;i++)o(t[i]);return o}return r})()({1:[function(require,module,exports){
"use strict";

/**
 * Places poster-style text inside a container
 *
 * The container will be emptied of whatever children it has (which allows successive invocations).
 *
 * @param {HTMLElement} container
 *  A block element in which to place the text.
 * @param {String} text
 *  The text to typeset
 * @param {Object} options
 *  Options:
 *    - maxLineHeight (default: 0.2) Maximum line height (as a percentage of the block's width)
 *    - minLineHeight (default: 0.044) Minimum line height (as a percentage of the block's width)
 *    - lineSpacing (default: 0) Space, in pixels, to place between lines.
 */
function render(container, text) {
  var options = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : {};
  var defaultOptions = {
    maxLineHeight: 0.2,
    minLineHeight: 0.044,
    lineSpacing: 0
  };

  var _Object$assign = Object.assign({}, defaultOptions, options),
      maxLineHeight = _Object$assign.maxLineHeight,
      minLineHeight = _Object$assign.minLineHeight,
      lineSpacing = _Object$assign.lineSpacing; // Clear the container


  while (container.firstChild) {
    container.removeChild(container.firstChild);
  }

  var lineContainer = document.createElement('div');
  lineContainer.classList.add('line-container');
  container.append(lineContainer);
  var lastHeight = 0;
  var lines = text.split('\n').map(function (line) {
    return line.trim();
  }).filter(function (each) {
    return each.length > 0;
  });
  lines.forEach(function (line) {
    var lineText = line;
    var smallText = false; // Check for escape characters

    if (line.substr(0, 2) === '@@') {
      lineText = line.substr(2).trim();
      smallText = true;
    }

    if (lineText.length > 0) {
      var words = lineText.split(' ');
      var fromWord = 0;
      var toWord = 0;

      while (fromWord < words.length) {
        var lineElement = document.createElement('div');
        lineElement.classList.add('line');
        lineContainer.append(lineElement);
        var sizeFactor = 1; // Add words until the line's height becomes smaller than the minimum

        do {
          toWord += 1;
          lineElement.textContent = words.slice(fromWord, toWord).join(' ');
          sizeFactor = container.clientWidth / lineElement.clientWidth;
        } while (toWord <= words.length && lineElement.clientHeight * sizeFactor / container.clientHeight >= minLineHeight); // If we exited the loop because the height became less than the minimum


        if (toWord <= words.length) {
          // If possible remove one word to go back above the minimum
          if (toWord > fromWord + 1) {
            toWord -= 1;
          }
        }

        lineElement.textContent = words.slice(fromWord, toWord).join(' ');

        if (smallText) {
          // Make the line the minimum height unless it doesn't fit and it needs shrinking
          // (this happens with single words that are very long)
          sizeFactor = Math.min(container.clientWidth / lineElement.clientWidth, minLineHeight * container.clientHeight / lineElement.clientHeight);
        } else {
          // Make the line the full width unless it goes over the max height and it needs
          // shrinking
          sizeFactor = Math.min(container.clientWidth / lineElement.clientWidth, maxLineHeight * container.clientHeight / lineElement.clientHeight);
        } // Center the line


        lineElement.style.left = "".concat((container.clientWidth - lineElement.clientWidth * sizeFactor) / 2, "px");
        lineElement.style.transform = "scale(".concat(sizeFactor, ")");
        lineElement.style.top = "".concat(lastHeight, "px");
        lastHeight += lineElement.clientHeight * sizeFactor + lineSpacing;
        fromWord = toWord;
      }
    }
  });
  lineContainer.style.top = "".concat((container.clientHeight - lastHeight) / 2, "px");
}

module.exports = {
  render: render
};

},{}]},{},[1])(1)
});
