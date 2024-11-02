(define-module (guix-home-config)
  #:use-module (gnu packages web-browsers)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages web)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages gnuzilla)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages base)
  #:use-module (gnu packages image-viewers)
  #:use-module (gnu packages rust-apps)
  #:use-module (gnu packages browser-extensions)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages texlive)
  #:use-module (gnu packages suckless)
  #:use-module (gnu packages crates-io)
  #:use-module (gnu packages mail)
  #:use-module (gnu packages rsync)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (gnu services)
  #:use-module (gnu services audio)
  #:use-module (gnu system shadow)
  #:use-module (guix gexp)
  #:use-module (guix store))

;; TODO: generate the final file from the alist
(define xdefaults-alist
  '(("XTerm*utf8" . "always")
    ("*background" . "#1E1E2E")
    ("*foreground" . "#CDD6F4")
    ("*faceName" . "Monospace")
    ("*faceSize" . "12")
    ("*cursorColor" . "#F5E0DC")
    ("*color0"  . "#45475A")
    ("*color8"  . "#585B70")
    ("*color1"  . "#F38BA8")
    ("*color9"  . "#F38BA8")
    ("*color2"  . "#A6E3A1")
    ("*color10" . "#A6E3A1")
    ("*color3"  . "#F9E2AF")
    ("*color11" . "#F9E2AF")
    ("*color4"  . "#89B4FA")
    ("*color12" . "#89B4FA")
    ("*color5"  . "#F5C2E7")
    ("*color13" . "#F5C2E7")
    ("*color6"  . "#94E2D5")
    ("*color14" . "#94E2D5")
    ("*color7"  . "#BAC2DE")
    ("*color15" . "#A6ADC8")))

(define alias-alist
  '(("c" . "clear")
    ("ghr" . "\"guix home reconfigure ~/src/panguia/home/home.scm\"")
    ("gsr" . "\"sudo guix system reconfigure ~/src/panguia/system/config.scm\"")))

;; define my Xsession config
(define xsession-config
  (string-append "xset r rate 300 50\n"
		 "setxkbmap -option \"caps:escape\"\n"
		 "bash ~/.fehbg\n"
		 "xsetroot -cursor_name left_ptr\n"))

(define git-config
  (string-append "a" "b"))

(define (concat-alist-entry str1 str2)
  (lambda (entry)
    (if (not (null? entry))
	(string-append str1 (car entry) str2 (cdr entry) "\n"))))

(define (alist-to-config alist str1 str2)
  (apply string-append (map (concat-alist-entry str1 str2) alist)))

(define (alist-value-map fn)
  (lambda (entry) ((car entry) . (fn (cdr entry)))))

(define (strq str) (string-append "\"" str "\""))

(define xdefaults-config
  (alist-to-config xdefaults-alist "" ": "))

;; (define alias-config
;;   (alist-to-config (map (alist-value-map strq) alias-alist) "alias " "="))

(define home-config
  (home-environment
   (packages (list
	      emacs
	      emacs-all-the-icons
	      emacs-jsonrpc
	      emacs-lsp-ivy
	      emacs-lsp-mode
	      emacs-general
	      emacs-geiser
	      emacs-nerd-icons
	      emacs-rustic
	      emacs-geiser-guile
	      emacs-use-package
	      emacs-undo-tree
	      emacs-counsel
	      emacs-company
	      emacs-eglot
	      emacs-evil
	      emacs-vterm
	      emacs-stumpwm-mode
	      emacs-guix
	      emacs-org-fragtog
	      emacs-yasnippet
	      emacs-evil-commentary
	      emacs-evil-org
	      emacs-which-key
	      emacs-page-break-lines
	      emacs-org-journal
	      emacs-org-roam
	      emacs-doom-modeline
	      emacs-org-superstar
	      emacs-projectile
	      emacs-dashboard
	      emacs-magit
	      emacs-elfeed
	      emacs-treemacs
	      emacs-evil-collection
	      emacs-elfeed-org
	      emacs-org-roam
	      emacs-pinentry
	      emacs-emms
	      emacs-ivy
	      emacs-sudo-edit
	      emacs-slime
	      emacs-catppuccin-theme
	      feh
	      light
	      git
	      icecat
	      isync
	      ublock-origin/icecat
	      nyxt
	      ncurses
	      msmtp
	      pavucontrol
	      kiwix-desktop
	      rust
	      rust-analyzer
	      rust-cargo
	      rust-clippy-0.0
	      rxvt-unicode
	      rsync
	      setxkbmap
	      xset
	      xsetroot
	      xterm
	      xclip
	      xinput
	      clang
	      dmenu
	      glibc-locales
	      font-gnu-freefont
	      font-dejavu
	      texlive))
   
   (services
    (list
     (service home-bash-service-type)

     ;; (service mpd-service-type
     ;;     (mpd-configuration
     ;; 	  (music-dir "~/music")
     ;; 	  (user-account "preston")))

     (simple-service 'xsession-config-service ;; TODO: Use macro
		     home-files-service-type
		     (list `(".Xsession"
			     ,(plain-file "Xsession-tmp" xsession-config))))

     (simple-service 'xsession-config-service
		     home-files-service-type
		     (list `(".Xdefaults"
			     ,(plain-file "Xdefaults-tmp" xdefaults-config))))

     (service home-files-service-type
	      `((".guile" ,%default-dotguile)))

     (service home-xdg-configuration-files-service-type
	      `(("gdb/gdbinit" ,%default-gdbinit)
		("nano/nanorc" ,%default-nanorc)))))))

home-config
