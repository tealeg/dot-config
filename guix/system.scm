;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu)
             (gnu packages linux)
             (nongnu packages linux)
             (nongnu system linux-initrd))
(use-service-modules
  cups
  desktop
  networking
  ssh
  xorg
  sound
  pm)

(use-package-modules emacs
		     wm
		     video
		     certs
		     version-control
		     terminals
		     disk
		     xdisorg
		     web-browsers
                     pulseaudio)

(operating-system
  (kernel linux)
  (firmware (list linux-firmware))
  (initrd microcode-initrd)
  (locale "en_GB.utf8")
  (timezone "Europe/Berlin")
  (keyboard-layout
    (keyboard-layout "us" "colemak" #:model "thinkpad"))
  (host-name "little-my")
  (users (cons* (user-account
                  (name "tealeg")
                  (comment "Geoffrey J. Teale")
                  (group "users")
                  (home-directory "/home/tealeg")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
    (append
     (list (specification->package "nss-certs")
	   sway
	    swaybg
	    swayidle
	    swaylock-effects
	    bemenu
	    emacs-next-pgtk
	    alacritty
	    youtube-dl
	    mpv
            pulseaudio
            tlp
	    git)
     %base-packages))
  (services
    (append
      (list (service openssh-service-type)
            (service cups-service-type)
            (service tlp-service-type (tlp-configuration
                                       (cpu-boost-on-ac? #t)
                                       (wifi-pwr-on-bat? #t)
                     ))
	    )
      (modify-services %desktop-services
                       (elogind-service-type config =>
                                             (elogind-configuration (inherit config)
                                                                    (handle-lid-switch-external-power 'suspend)))
                       (gdm-service-type config => (gdm-configuration
                                                   (inherit config)
                                                   (wayland? #t)))
                       (guix-service-type config => (guix-configuration
                                                    (inherit config)
                                                    (substitute-urls
                                                     (append (list "https://substitutes.nonguix.org")
                                                             %default-substitute-urls))
                                                    (authorized-keys
                                                     (append (list (local-file "./signing-key.pub"))
                  %default-authorized-guix-keys)))))))

  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (targets (list "/boot/efi"))
      (keyboard-layout keyboard-layout)))
  (swap-devices
    (list (swap-space
            (target
              (uuid "b9840444-8235-42f7-8261-48f09aad0da7")))))
  (file-systems
    (cons* (file-system
             (mount-point "/boot/efi")
             (device (uuid "AF90-DE71" 'fat32))
             (type "vfat"))
           (file-system
             (mount-point "/")
             (device
               (uuid "60ce5fba-acfa-4255-829e-9fc9ed64e179"
                     'ext4))
             (type "ext4"))
           %base-file-systems)))
