(use-modules (gnu)
	     (nongnu packages linux)
	     (gnu packages wm)
	     (gnu packages fonts)
	     (gnu packages lisp))
(use-service-modules cups desktop networking ssh xorg)

(operating-system
  ;; todo: replace with linux-libre to run with entirely free system
  (kernel linux)
  ;; todo: delete once the wifi card arrives
  (firmware (cons* iwlwifi-firmware %base-firmware))
  (locale "en_CA.utf8")
  (timezone "America/Vancouver")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "mastex-bintyl")

  (users (cons* (user-account
                  (name "preston")
                  (comment "Preston Pan")
                  (group "users")
                  (home-directory "/home/preston")
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  (packages (append (list sbcl stumpwm
			  sbcl-stumpwm-swm-gaps
			  sbcl-stumpwm-hostname
			  sbcl-stumpwm-notify
			  sbcl-stumpwm-battery-portable
			  sbcl-stumpwm-wifi
			  sbcl-stumpwm-ttf-fonts
			  font-dejavu
			  stumpish)
                    %base-packages))

  (services
   (append (list
                 (service openssh-service-type)
                 (service tor-service-type)
                 (service cups-service-type)
                 (set-xorg-configuration
                  (xorg-configuration (keyboard-layout keyboard-layout))))
           %desktop-services))

  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (targets (list "/dev/sda"))
                (keyboard-layout keyboard-layout)))

  (swap-devices (list (swap-space
		       (target (uuid
				"c6e26031-6854-44f9-bb76-ff2c0306b1eb")))))

  (file-systems (cons* (file-system
                        (mount-point "/")
                        (device (uuid
                                 "04211973-f744-4a48-8987-6e6d1014fe7e"
                                 'ext4))
                        (type "ext4")) %base-file-systems)))
