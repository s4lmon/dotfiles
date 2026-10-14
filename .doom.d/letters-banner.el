;;; letters-banner.el --- Letters artwork for Doom -*- lexical-binding: t; -*-

;; Adapted from https://github.com/wwxodus/Letters
;; Copyright (c) 2024 washedmyhair
;;
;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:
;;
;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

(defconst letters_banner_glyphs
  '(("#b16286"
     "     ___      "
     "    /\\  \\     "
     "   /::\\  \\    "
     "  /:/\\:\\  \\   "
     " /::\\~\\:\\  \\  "
     "/:/\\:\\ \\:\\__\\ "
     "\\:\\~\\:\\ \\/__/ "
     " \\:\\ \\:\\__\\   "
     "  \\:\\ \\/__/   "
     "   \\:\\__\\     "
     "    \\/__/     ")
    ("#8f3f71"
     "     ___      "
     "    /\\  \\     "
     "   /||\\  \\    "
     "  /|/\\|\\  \\   "
     " /|/ /||\\  \\  "
     "/|/ /|/\\|\\__\\ "
     "\\/_/|/ /|/  / "
     "  /|/ /|/  /  "
     "  \\/_/|/  /   "
     "    /|/  /    "
     "    \\/__/     ")
    ("#076678"
     "     ___      "
     "    /\\  \\     "
     "   /::\\  \\    "
     "  /:/\\:\\  \\   "
     " /::\\~\\:\\  \\  "
     "/:/\\:\\ \\:\\__\\ "
     "\\/__\\:\\/:/  / "
     "     \\::/  /  "
     "     /:/  /   "
     "    /:/  /    "
     "    \\/__/     ")
    ("#98971a"
     "     ___      "
     "    /\\  \\     "
     "   /::\\  \\    "
     "  /:/\\:\\  \\   "
     " /:/  \\:\\  \\  "
     "/:/__/ \\:\\__\\ "
     "\\:\\  \\  \\/__/ "
     " \\:\\  \\       "
     "  \\:\\  \\      "
     "   \\:\\__\\     "
     "    \\/__/     ")
    ("#8ec07c"
     "     ___      "
     "    /\\  \\     "
     "   /||\\  \\    "
     "  /|/\\|\\  \\   "
     " _\\|\\~\\|\\  \\  "
     "/\\ \\|\\ \\|\\__\\ "
     "\\|\\ \\|\\ \\/__/ "
     " \\|\\ \\|\\__\\   "
     "  \\|\\/|/  /   "
     "   \\||/  /    "
     "    \\/__/     "))
  "Coloured EMACS letter artwork from Letters.")

(defun letters_banner ()
  "Return the coloured Letters banner for Doom's dashboard."
  (mapconcat
   (lambda (line_index)
     (mapconcat
      (lambda (glyph)
        (propertize (nth line_index (cdr glyph))
                    'face (list :foreground (car glyph))))
      letters_banner_glyphs ""))
   (number-sequence 0 (1- (length (cdar letters_banner_glyphs)))) "\n"))

(setq fancy-splash-image nil
      +dashboard-ascii-banner-fn #'letters_banner)

;;; letters-banner.el ends here
