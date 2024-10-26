(define-module (guix-home-config)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages web)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages version-control)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu packages gnuzilla)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages linux)
  #:use-module (gnu home services shells)
  #:use-module (gnu services)
  #:use-module (gnu packages base)
  #:use-module (gnu packages rust-apps)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages llvm)
  #:use-module (gnu system shadow))

;; define my Xsession config
(define xsession-config
  (string-append "xset r rate 300 50\n"
		 "setxkbmap -option \"caps:escape\"\n"))

(define zsh-aliases
  (string-append "alias c=clear\n"
		 "alias rb=\"guix home reconfigure\"\n"))

;; TODO: generate the final file from the alist
(define xdefaults-alist
  '(("XTerm*utf8" . "always")))

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
	      light
	      git
	      icecat
	      nyxt
	      ncurses
	      pavucontrol
	      rust
	      rust-analyzer
	      rust-cargo
	      setxkbmap
	      xset
	      xterm
	      clang
	      ))
   
   (services
    (list
     (service home-zsh-service-type)

     (service home-files-service-type
	      `((".guile" ,%default-dotguile)
		(".Xdefaults" ,%default-xdefaults)
		(".Xsession" ,xsession-config)))

     (service home-xdg-configuration-files-service-type
	      `(("gdb/gdbinit" ,%default-gdbinit)
		("nano/nanorc" ,%default-nanorc)))))))

home-config
