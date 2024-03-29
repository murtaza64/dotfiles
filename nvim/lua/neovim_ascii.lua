local asciis = {
  {
   [[ _      _____ ____  _     _  _     ]],
   [[/ \  /|/  __//  _ \/ \ |\/ \/ \__/|]],
   [[| |\ |||  \  | / \|| | //| || |\/||]],
   [[| | \|||  /_ | \_/|| \// | || |  ||]],
   [[\_/  \|\____\\____/\__/  \_/\_/  \|]],
  },
  {
   [[                        _           ]],
   [[                       (_)          ]],
   [[  _ __   ___  _____   ___ _ __ ___  ]],
   [[ | '_ \ / _ \/ _ \ \ / / | '_ ` _ \ ]],
   [[ | | | |  __/ (_) \ V /| | | | | | |]],
   [[ |_| |_|\___|\___/ \_/ |_|_| |_| |_|]],
  },
  {
   [[ _  _  ____  _____  _  _  ____  __  __ ]],
   [[( \( )( ___)(  _  )( \/ )(_  _)(  \/  )]],
   [[ )  (  )__)  )(_)(  \  /  _)(_  )    ( ]],
   [[(_)\_)(____)(_____)  \/  (____)(_/\/\_)]]
  },
  {
   [[.------..------..------..------..------..------.]],
   [[|N.--. ||E.--. ||O.--. ||V.--. ||I.--. ||M.--. |]],
   [[| :(): || (\/) || :/\: || :(): || (\/) || (\/) |]],
   [[| ()() || :\/: || :\/: || ()() || :\/: || :\/: |]],
   [[| '--'N|| '--'E|| '--'O|| '--'V|| '--'I|| '--'M|]],
   [[`------'`------'`------'`------'`------'`------']]
  },
  {
   [[ ____     ___   ___   __ __  ____  ___ ___ ]],
   [[|    \   /  _] /   \ |  |  ||    ||   |   |]],
   [[|  _  | /  [_ |     ||  |  | |  | | _   _ |]],
   [[|  |  ||    _]|  O  ||  |  | |  | |  \_/  |]],
   [[|  |  ||   [_ |     ||  :  | |  | |   |   |]],
   [[|  |  ||     ||     | \   /  |  | |   |   |]],
   [[|__|__||_____| \___/   \_/  |____||___|___|]],
  },
  {
   [[                       _           ]],
   [[                      (_)          ]],
   [[ _ __   ___  _____   ___ _ __ ___  ]],
   [[| '_ \ / _ \/ _ \ \ / / | '_ ` _ \ ]],
   [[| | | |  __/ (_) \ V /| | | | | | |]],
   [[|_| |_|\___|\___/ \_/ |_|_| |_| |_|]],
  },
  {
   [[          (        )   (      )    ]],
   [[  (      ))\  (   /((  )\    (     ]],
   [[  )\ )  /((_) )\ (_))\((_)   )\  ' ]],
   [[ _(_/( (_))  ((_)_)((_)(_) _((_))  ]],
   [[| ' \))/ -_)/ _ \\ V / | || '  \() ]],
   [[|_||_| \___|\___/ \_/  |_||_|_|_|  ]],
  },
  {
   [[         (      )  (     )    ]],
   [[  (     ))\ (  /(( )\   (     ]],
   [[  )\ ) /((_))\(_))((_)  )\  ' ]],
   [[ _(_/((_)) ((_))((_|_)_((_))  ]],
   [[| ' \)) -_) _ \ V /| | '  \() ]],
   [[|_||_|\___\___/\_/ |_|_|_|_|  ]],
  },
  {
   [[ __ _  ____  __   _  _  __  _  _ ]],
   [[(  ( \(  __)/  \ / )( \(  )( \/ )]],
   [[/    / ) _)(  O )\ \/ / )( / \/ \]],
   [[\_)__)(____)\__/  \__/ (__)\_)(_/]]
  },
  {
   [[                         .__         ]],
   [[  ____   ____  _______  _|__| _____  ]],
   [[ /    \_/ __ \/  _ \  \/ /  |/     \ ]],
   [[|   |  \  ___(  <_> )   /|  |  Y Y  \]],
   [[|___|  /\___  >____/ \_/ |__|__|_|  /]],
   [[     \/     \/                    \/ ]]
  },
  {
   [[.-. .-..----..----. .-. .-..-..-.   .-.]],
   [[|  `| || {_ /  {}  \| | | || ||  `.'  |]],
   [[| |\  || {__\      /\ \_/ /| || |\ /| |]],
   [[`-' `-'`----'`----'  `---' `-'`-' ` `-']]
  },
  {
   [[                       _           ]],
   [[ _ __   ___  _____   _(_)_ __ ___  ]],
   [[| '_ \ / _ \/ _ \ \ / / | '_ ` _ \ ]],
   [[| | | |  __/ (_) \ V /| | | | | | |]],
   [[|_| |_|\___|\___/ \_/ |_|_| |_| |_|]],
  },
  {
   [[                 _       ]],
   [[ ___ ___ ___ _ _|_|_____ ]],
   [[|   | -_| . | | | |     |]],
   [[|_|_|___|___|\_/|_|_|_|_|]],
  },
  {
   [[                          _         ]],
   [[   ____  ___  ____ _   __(_)___ ___ ]],
   [[  / __ \/ _ \/ __ \ | / / / __ `__ \]],
   [[ / / / /  __/ /_/ / |/ / / / / / / /]],
   [[/_/ /_/\___/\____/|___/_/_/ /_/ /_/ ]],
  },
  {
   [[                   _       ]],
   [[  _ _  ___ _____ _(_)_ __  ]],
   [[ | ' \/ -_) _ \ V / | '  \ ]],
   [[ |_||_\___\___/\_/|_|_|_|_|]],
  },
  {
   [[                     _     ]],
   [[  ___  ___ ___ _  __(_)_ _ ]],
   [[ / _ \/ -_) _ \ |/ / /  ' \]],
   [[/_//_/\__/\___/___/_/_/_/_/]],
  },
  {
   [[                               ,--.           ]],
   [[,--,--,  ,---.  ,---.,--.  ,--.`--',--,--,--. ]],
   [[|      \| .-. :| .-. |\  `'  / ,--.|        | ]],
   [[|  ||  |\   --.' '-' ' \    /  |  ||  |  |  | ]],
   [[`--''--' `----' `---'   `--'   `--'`--`--`--' ]],
  },
  {
   [[                        _           ]],
   [[  _ __   ___  _____   _(_)_ __ ___  ]],
   [[ | '_ \ / _ \/ _ \ \ / / | '_ ` _ \ ]],
   [[ | | | |  __/ (_) \ V /| | | | | | |]],
   [[ |_| |_|\___|\___/ \_/ |_|_| |_| |_|]],
  },
  {
   [[        •   ]],
   [[┏┓┏┓┏┓┓┏┓┏┳┓]],
   [[┛┗┗ ┗┛┗┛┗┛┗┗]],
  },
  {
   [[                                    _            ]],
   [[  _ _      ___     ___    __ __    (_)    _ __   ]],
   [[ | ' \    / -_)   / _ \   \ V /    | |   | '  \  ]],
   [[ |_||_|   \___|   \___/   _\_/_   _|_|_  |_|_|_| ]],
   [[_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""| ]],
   [["`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-' ]]
  },
  {
   [[ .-. .-.,---.   .---..-.   .-.,-.         ]],
   [[ |  \| || .-'  / .-. )\ \ / / |(||\    /| ]],
   [[ |   | || `-.  | | |(_)\ V /  (_)|(\  / | ]],
   [[ | |\  || .-'  | | | |  ) /   | |(_)\/  | ]],
   [[ | | |)||  `--.\ `-' / (_)    | || \  / | ]],
   [[ /(  (_)/( __.' )---'         `-'| |\/| | ]],
   [[(__)   (__)    (_)               '-'  '-' ]]
  },
  {
   [[                                 _                ]],
   [[                                (_)               ]],
   [[ _ .--.  .---.   .--.   _   __  __   _ .--..--.   ]],
   [[[ `.-. |/ /__\\/ .'`\ \[ \ [  ][  | [ `.-. .-. |  ]],
   [[ | | | || \__.,| \__. | \ \/ /  | |  | | | | | |  ]],
   [[[___||__]'.__.' '.__.'   \__/  [___][___||__||__] ]],
  },
  {
   [[███    ██ ███████  ██████  ██    ██ ██ ███    ███ ]],
   [[████   ██ ██      ██    ██ ██    ██ ██ ████  ████ ]],
   [[██ ██  ██ █████   ██    ██ ██    ██ ██ ██ ████ ██ ]],
   [[██  ██ ██ ██      ██    ██  ██  ██  ██ ██  ██  ██ ]],
   [[██   ████ ███████  ██████    ████   ██ ██      ██ ]],
  },
  {
   [[███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
   [[████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
   [[██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
   [[██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
   [[██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
   [[╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
  },
  {
   [[┌┐┌┌─┐┌─┐┬  ┬┬┌┬┐]],
   [[│││├┤ │ │└┐┌┘││││]],
   [[┘└┘└─┘└─┘ └┘ ┴┴ ┴]]
  },
  {
   [[ ▐ ▄ ▄▄▄ .       ▌ ▐·▪  • ▌ ▄ ·. ]],
   [[•█▌▐█▀▄.▀·▪     ▪█·█▌██ ·██ ▐███▪]],
   [[▐█▐▐▌▐▀▀▪▄ ▄█▀▄ ▐█▐█•▐█·▐█ ▌▐▌▐█·]],
   [[██▐█▌▐█▄▄▌▐█▌.▐▌ ███ ▐█▌██ ██▌▐█▌]],
   [[▀▀ █▪ ▀▀▀  ▀█▄▀▪. ▀  ▀▀▀▀▀  █▪▀▀▀]]
  },
  {
   [[   ▄   ▄███▄   ████▄     ▄   ▄█ █▀▄▀█ ]],
   [[    █  █▀   ▀  █   █      █  ██ █ █ █ ]],
   [[██   █ ██▄▄    █   █ █     █ ██ █ ▄ █ ]],
   [[█ █  █ █▄   ▄▀ ▀████  █    █ ▐█ █   █ ]],
   [[█  █ █ ▀███▀           █  █   ▐    █  ]],
   [[█   ██                  █▐        ▀   ]],
   [[                        ▐             ]]
  },
  {
   [[|\| [- () \/ | |\/| ]],
  },
  {
   [[                                    **            ]],
   [[                                   //             ]],
   [[ *******   *****   ******  **    ** ** ********** ]],
   [[//**///** **///** **////**/**   /**/**//**//**//**]],
   [[ /**  /**/*******/**   /**//** /** /** /** /** /**]],
   [[ /**  /**/**//// /**   /** //****  /** /** /** /**]],
   [[ ***  /**//******//******   //**   /** *** /** /**]],
   [[///   //  //////  //////     //    // ///  //  // ]]
  },
  {
   [[                 #      ]],
   [[##  ### ### # #     ### ]],
   [[# # ##  # # # #  #  ### ]],
   [[# # ### ###  #   ## # # ]],
  },
  {
   [[88b 88 888888  dP"Yb  Yb    dP 88 8b    d8 ]],
   [[88Yb88 88__   dP   Yb  Yb  dP  88 88b  d88 ]],
   [[88 Y88 88""   Yb   dP   YbdP   88 88YbdP88 ]],
   [[88  Y8 888888  YbodP     YP    88 88 YY 88 ]]
  },
  {
   [[. . .-. .-. . . .-. .  . ]],
   [[|\| |-  | | | |  |  |\/| ]],
   [[' ` `-' `-' `.' `-' '  ` ]],
  },
  {
   [[.:;S;:.         .:;S;:. .:;S;.          .:;S;:. ]],
   [[ /      S  S  S S     S      :: .:;s;:'  )      ]],
   [[`:;S;:' `:;S;:' `:;S;:' `:;S;'          `:;S;:' ]],
  },
  {
   [[d s  b d sss     sSSSs   d    b d d s   sb ]],
   [[S  S S S        S     S  S    S S S  S S S ]],
   [[S   SS S       S       S S    S S S   S  S ]],
   [[S    S S sSSs  S       S S    S S S      S ]],
   [[S    S S       S       S S    S S S      S ]],
   [[S    S S        S     S   S   S S S      S ]],
   [[P    P P sSSss   "sss"     "ssS P P      P ]],
  },
  {
   [[ _,  _,____,____,__  _,__, __, _,]],
   [[(-|\ |(-|_,(-/  (-\  /(-| (-|\/| ]],
   [[ _| \|,_|__,_\__/,_\/  _|_,_| _|,]],
   [[(     (    (     (    (   (      ]]
  },
  {
   [[                 ii       ]],
   [[nnn  eee ooo v v    mmmm  ]],
   [[n  n e e o o v v ii m m m ]],
   [[n  n ee  ooo  v  ii m m m ]],
  },
  {
   [[ #    # ######  ####  #    # # #    # ]],
   [[ ##   # #      #    # #    # # ##  ## ]],
   [[ # #  # #####  #    # #    # # # ## # ]],
   [[ #  # # #      #    # #    # # #    # ]],
   [[ #   ## #      #    #  #  #  # #    # ]],
   [[ #    # ######  ####    ##   # #    # ]],
  },
  {
   [[ , __     ___    __.  _   __ ` , _ , _  ]],
   [[ |'  `. .'   ` .'   \ |   /  | |' `|' `.]],
   [[ |    | |----' |    | `  /   | |   |   |]],
   [[ /    | `.___,  `._.'  \/    / /   '   /]],
  },
  {
   [[|\|[-()\/||\/|]]
  },
  {
   [[___________________________________]],
   [[                           ,       ]],
   [[----__----__----__------------_--_-]],
   [[  /   ) /___) /   ) | /  /   / /  )]],
   [[_/___/_(___ _(___/__|/__/___/_/__/_]],
  },
  {
   [[__  _  _     o __ ]],
   [[| |(/_(_)\_/ | |||]]
  },
  {
   [[.-. .-..----. .---..-.   .-..-..-.  .-. ]],
   [[|  \{ |} |__}/ {-. \\ \_/ / { |}  \/  { ]],
   [[| }\  {} '__}\ '-} / \   /  | }| {  } | ]],
   [[`-' `-'`----' `---'   `-'   `-'`-'  `-' ]],
  },
  {
   [[.##..##..######...####...##..##..######..##...##.]],
   [[.###.##..##......##..##..##..##....##....###.###.]],
   [[.##.###..####....##..##..##..##....##....##.#.##.]],
   [[.##..##..##......##..##...####.....##....##...##.]],
   [[.##..##..######...####.....##....######..##...##.]],
   [[.................................................]]
  },
  {
   [[ _      ____  ___   _      _   _     ]],
   [[| |\ | | |_  / / \ \ \  / | | | |\/| ]],
   [[|_| \| |_|__ \_\_/  \_\/  |_| |_|  | ]]
  },
  {
   [[   _   _   _   _   _   _  ]],
   [[  / \ / \ / \ / \ / \ / \ ]],
   [[ ( n | e | o | v | i | m )]],
   [[  \_/ \_/ \_/ \_/ \_/ \_/ ]]
  },
  {
   [[                          __           ]],
   [[.-----.-----.-----.--.--.|__|.--------.]],
   [[|     |  -__|  _  |  |  ||  ||        |]],
   [[|__|__|_____|_____|\___/ |__||__|__|__|]],
  },
  {
   [[                        .-.  .-.             ]],
   [[  . ,';.  .-.  .-. _.;  :    `-' . ,';.,';.  ]],
   [[  ;;  ;;.;.-' ;   ;';   ;   ;'   ;;  ;;  ;;  ]],
   [[ ';  ;;  `:::'`;;'  `._.'_.;:._.';  ;;  ';   ]],
   [[ ;    `.                       _;        `-' ]]
  },
  {
   [[eeeee eeee eeeee ee   e e  eeeeeee ]],
   [[8   8 8    8  88 88   8 8  8  8  8 ]],
   [[8e  8 8eee 8   8 88  e8 8e 8e 8  8 ]],
   [[88  8 88   8   8  8  8  88 88 8  8 ]],
   [[88  8 88ee 8eee8  8ee8  88 88 8  8 ]],
  },
  {
   [[._  _  _ .  ,*._ _ ]],
   [[[ )(/,(_) \/ |[ | )]],
  },
  {
   [[.%%..%%..%%%%%%...%%%%...%%..%%..%%%%%%..%%...%%.]],
   [[.%%%.%%..%%......%%..%%..%%..%%....%%....%%%.%%%.]],
   [[.%%.%%%..%%%%....%%..%%..%%..%%....%%....%%.%.%%.]],
   [[.%%..%%..%%......%%..%%...%%%%.....%%....%%...%%.]],
   [[.%%..%%..%%%%%%...%%%%.....%%....%%%%%%..%%...%%.]],
   [[.................................................]]
  },
  {
   [[ ____     ___   ___   __ __  ____  ___ ___ ]],
   [[|    \   /  _] /   \ |  T  |l    j|   T   T]],
   [[|  _  Y /  [_ Y     Y|  |  | |  T | _   _ |]],
   [[|  |  |Y    _]|  O  ||  |  | |  | |  \_/  |]],
   [[|  |  ||   [_ |     |l  :  ! |  | |   |   |]],
   [[|  |  ||     Tl     ! \   /  j  l |   |   |]],
   [[l__j__jl_____j \___/   \_/  |____jl___j___j]],
  },
  {
   [[                          __          ]],
   [[ .-----.-----.-----.--.--|__.--------.]],
   [[ |     |  -__|  _  |  |  |  |        |]],
   [[ |__|__|_____|_____|\___/|__|__|__|__|]],
  },
  {
   [[ ____  _  __, _o ______ ]],
   [[/ / <_</_(_)\/<_/ / / <_]],
  },
  {
   [[ __   _ _______  _____  _    _ _____ _______]],
   [[ | \  | |______ |     |  \  /    |   |  |  |]],
   [[ |  \_| |______ |_____|   \/   __|__ |  |  |]],
  },
  {
   [[_  _ ____ ____ _  _ _ _  _ ]],
   [[|\ | |___ |  | |  | | |\/| ]],
   [[| \| |___ |__|  \/  | |  | ]],
  },
  {
   [[ __ _ ____ ____ _  _ _ _  _]],
   [[ | \| |=== [__]  \/  | |\/|]]
  },
  {
   [[            .     ]],
   [[.-..-,.-.. ...-.-.]],
   [[' '`'-`-' ` '' ' ']],
  },
  {
   [[  O/   \O/  \O/   O/  \O/ \O/ ]],
   [[ <|     Y   _Y.___|.___Y   Y  ]],
   [[ / \   / \_| |    |    |  / \ ]],
   [[_| |_./   \, |_   |_   |__| |_]]
  },
  {
   [[n ovim]],
   [[ X    ]],
   [[ X    ]],
   [[ X    ]],
   [[ X    ]],
   [[ X    ]],
   [[ .    ]],
   [[neovim]],
  },
  {
   [[110 101 111 118 105 109 ]]
  },
  {
   [[                           .-.             ]],
   [[ .  .-.   .-.  .-._.)   .-.`-'.  .-. .-.   ]],
   [[  )/   )./.-'_(   )(   /  /    )/   )   )  ]],
   [[ '/   ( (__.'  `-'  \_/_.(__. '/   /   (   ]],
   [[       `-                               `-']]
  },
  {
   [[ +-+-+-+-+-+-+]],
   [[ |n|e|o|v|i|m|]],
   [[ +-+-+-+-+-+-+]]
  },
  {
   [[__  __ _____  _____  __ __ __ ___  __ ]],
   [[||\\|| ||==  ((   )) \\ // || || \/ | ]],
   [[|| \|| ||___  \\_//   \V/  || ||    | ]]
  },
  {
   [[ __  __  ____   ___   __ __ __ ___  ___]],
   [[ ||\ || ||     // \\  || || || ||\\//||]],
   [[ ||\\|| ||==  ((   )) \\ // || || \/ ||]],
   [[ || \|| ||___  \\_//   \V/  || ||    ||]],
  },
  {
   [[                     _        ]],
   [[._ _  ___  ___  _ _ <_>._ _ _ ]],
   [[| ' |/ ._>/ . \| | || || ' ' |]],
   [[|_|_|\___.\___/|__/ |_||_|_|_|]],
  },
  {
   [[###########################]],
   [[##':v:`#####(:)#####\`.'/##]],
   [[##(o:0)#####|:|#####(o:o)##]],
   [[###(:)######|:|######\:/:\#]],
   [[######################"####]]
  },
  {
   [[  _  _  _    ()  _ _ ]],
   [[|/ \/o\/o\\V7|||/ \ \]],
   [[L_n|\( \_/ V L|L_n_n|]],
  },
  {
   [[  _     __  _      ()_   ]],
   [[ / \/7,'o/,'o|/7/7/7/ \'\]],
   [[/_n_/ |_( |_,'|,'///_nn_/]],
  },
  {
   [[neovim]],
  },
  {
   [[                      _         ]],
   [[                     (_)        ]],
   [[ ____  ___  ___  _ _  _  __  __ ]],
   [[( __ )( o_)( o )( V )( )( _`'_ )]],
   [[/_\/_\ \(   \_/  \_/ /_\/_\`'/_\]],
  },
  {
   [[                 o       ]],
   [[ _ _  __ __ __ _ _  _  _ ]],
   [[((\( (('((_)\(/'(( ((`1( ]],
  },
  {
   [[                               ''             ]],
   [[`||''|,  .|''|, .|''|, \\  //  ||  '||),,(|,  ]],
   [[ ||  ||  ||..|| ||  ||  \\//   ||   || || ||  ]],
   [[.||  ||. `|...  `|..|'   \/   .||. .||    ||. ]],
  },
  {
   [[ ____  ____   __    ___        ____ ]],
   [[|__  ||    | /  \  /  _| ____ |_   |]],
   [[ _/ / ||_| || |] ||  |_ |____| _< < ]],
   [[|____||_||_| \__/  \___|      |____|]]
  },
  {
   [[               '         ]],
   [[|/~\ /~//~\\  /||/~\ /~\ ]],
   [[|   |\/_\_/ \/ ||   |   |]],
  },
  {
   [[                         _          ]],
   [[                        :_;         ]],
   [[,-.,-. .--.  .--. .-..-..-.,-.,-.,-.]],
   [[: ,. :' '_.'' .; :: `; :: :: ,. ,. :]],
   [[:_;:_;`.__.'`.__.'`.__.':_;:_;:_;:_;]],
  },
  {
   [[__   ____ ____ _  _ ____ _    ]],
   [[| \|\| __\|   ||| |\|___\|\/\ ]],
   [[|  \||  ]_| . |||/ /| /  |   \]],
   [[|/\_/|___/|___/|__/ |/   |/v\/]]
  },
  {
   [[                  ;     '          ]],
   [[\\/\\  _-_   /'\\ \\/\ \\ \\/\\/\\ ]],
   [[|| || || \\ || || || | || || || || ]],
   [[|| || ||/   || || || | || || || || ]],
   [[\\ \\ \\,/  \\,/  \\/  \\ \\ \\ \\ ]],
  },
  {
   [[ _  _____ ___  _________ _  _   _ ]],
   [[| |/ / __) _ \(  _____  ) || | | |]],
   [[| / /> _| (_) ) |_/ \_| | || |_| |]],
   [[|__/ \___)___/ \___^___/ \_) ._,_|]],
   [[                           | |    ]],
   [[                           |_|    ]]
  },
  {
   [[ .-.-. .-.-. .-.-. .-.-. .-.-. .-.-. ]],
   [[( n .'( e .'( o .'( v .'( i .'( m .' ]],
   [[ `.(   `.(   `.(   `.(   `.(   `.(   ]],
  },
  {
   [[.-.-. .-.-. .-.-. .-.-. .-.-. .-.-.  ]],
   [['. n )'. e )'. o )'. v )'. i )'. m ) ]],
   [[  ).'   ).'   ).'   ).'   ).'   ).'  ]],
  },
  {
   [[6E 65 6F 76 69 6D ]]
  },
  {
   [[                          <~)_    ;. ,-==.    ]],
   [[                 ||  .-.   ( v~\ ; |  (  (\   ]],
   [[        ....     || _|_ \   \_/' `.|   |\.\\  ]],
   [[^^^^^^^ `=.`''===.' (_)     /\     |  _]_]`\\ ]]
  },
  {
   [[neovim]],
   [[ *  * ]],
   [[* *  *]],
   [[   *  ]],
   [[     *]],
   [[** *  ]],
   [[  *   ]],
   [[    * ]]
  },
  {
   [[                  ,     ]],
   [[__    _  ____ _    ___  ]],
   [[/ (__(/_(_) (/___(_// (_]],
  },
  {
   [[   _     '_  ]],
   [[/)(-()\////) ]],
  },
  {
   [[                        _           ]],
   [[  _ __   ___  _____   _(_)_ __ ___  ]],
   [[ | '_ \ / _ \/ _ \ \ / / | '_ ` _ \ ]],
   [[ | | | |  __/ (_) \ V /| | | | | | |]],
   [[ |_| |_|\___|\___/ \_/ |_|_| |_| |_|]],
  },
  {
   [[ __  _  ____  ____ __  __ _  __  __ ]],
   [[|  \| || ===|/ () \\ \/ /| ||  \/  |]],
   [[|_|\__||____|\____/ \__/ |_||_|\/|_|]]
  },
  {
   [[ ____,   ____, ____, __  _, ____, _____,  ]],
   [[(-|  |  (-|_, (-/  \(-\ |  (-|   (-| | |  ]],
   [[ _|  |_, _|__,  \__/   \|   _|__, _| | |_,]],
   [[(       (                  (     (        ]]
  },
  {
   [[  ,__,   _   _,__,     .  ,____, ]],
   [[_/ / (__(/__(_/  (_/__/__/ / / (_]],
  },
  {
   [[      ___  __               ]],
   [[|\ | |__  /  \ \  / |  |\/| ]],
   [[| \| |___ \__/  \/  |  |  | ]],
  },
  {
   [[                            o         ]],
   [[odYo. .oPYo. .oPYo. o    o o8 ooYoYo. ]],
   [[8' `8 8oooo8 8    8 Y.  .P  8 8' 8  8 ]],
   [[8   8 8.     8    8 `b..d'  8 8  8  8 ]],
   [[8   8 `Yooo' `YooP'  `YP'   8 8  8  8 ]],
   [[..::..:.....::.....:::...:::....:..:..]],
   [[::::::::::::::::::::::::::::::::::::::]],
   [[::::::::::::::::::::::::::::::::::::::]]
  },
  {
   [[ _______ ______ ________ _______ ___  __   __.]],
   [[|.  __  |____  |.  ___  |_____  |_  | \ \ / / ]],
   [[ | |  | | _  | || |   | | _   | | | |  \ V /  ]],
   [[ | | _| || | |_|| |___| || |  | | | |___\  \  ]],
   [[ |_||___|| |    |_______||_|  |_| | |______|  ]],
   [[         |_|                      |_|         ]]
  },
  {
   [[                                   ||             ]],
   [[.. ...     ....    ...   .... ... ...  .. .. ..   ]],
   [[ ||  ||  .|...|| .|  '|.  '|.  |   ||   || || ||  ]],
   [[ ||  ||  ||      ||   ||   '|.|    ||   || || ||  ]],
   [[.||. ||.  '|...'  '|..|'    '|    .||. .|| || ||. ]],
  },
  {
   [[ _______ _______ _______ _______ _______ _______ ]],
   [[|\     /|\     /|\     /|\     /|\     /|\     /|]],
   [[| +---+ | +---+ | +---+ | +---+ | +---+ | +---+ |]],
   [[| |   | | |   | | |   | | |   | | |   | | |   | |]],
   [[| |n  | | |e  | | |o  | | |v  | | |i  | | |m  | |]],
   [[| +---+ | +---+ | +---+ | +---+ | +---+ | +---+ |]],
   [[|/_____\|/_____\|/_____\|/_____\|/_____\|/_____\|]],
  },
  {
   [[                          _         ]],
   [[|-     -     -            +   |- -  ]],
   [[| |   |/    | |   |/      |   | | | ]],
   [[       --    -                      ]],
  },
  {
   [[                               __                ]],
   [[  ___      __    ___   __  __ /\_\    ___ ___    ]],
   [[/' _ `\  /'__`\ / __`\/\ \/\ \\/\ \ /' __` __`\  ]],
   [[/\ \/\ \/\  __//\ \L\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
   [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
   [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
  },
  {
   [[                              iii             ]],
   [[nn nnn    eee   oooo  vv   vv     mm mm mmmm  ]],
   [[nnn  nn ee   e oo  oo  vv vv  iii mmm  mm  mm ]],
   [[nn   nn eeeee  oo  oo   vvv   iii mmm  mm  mm ]],
   [[nn   nn  eeeee  oooo     v    iii mmm  mm  mm ]],
  },
  {
   [[.-..-..---..----..-..-..-..-.-.-.]],
   [[| .` || |- | || | \  / | || | | |]],
   [[`-'`-'`---'`----'  `'  `-'`-'-'-']],
  },
  {
   [[                    ++      ]],
   [[:::\ :~~/ ,::\ :\:| :| :\/| ]],
   [[:|:| :::, `::/  :/  :| :::| ]],
  },
  {
   [[/=\ /=\ /=\ | | = /=\=\ ]],
   [[| | \=  \=/ \\/ | | | | ]],
  },
  {
   [[               '         ]],
   [[|/~\ /~//~\\  /||/~\ /~\ ]],
   [[|   |\/_\_/ \/ ||   |   |]],
  },
  {
   [[     _             ]],
   [[ |\ |/  | |/ _| ||\]],
  },
  {
   [[ ._   _   _     o ._ _  ]],
   [[ | | (/_ (_) \/ | | | | ]],
  },
  {
   [[                       _           ]],
   [[  __ _ ___   _____   _(_) ___ __ _ ]],
   [[ / _` / _ \ / _ \ \ / | |/ _ ' _` |]],
   [[| | | \__  | (_) \ V /| | | | | | |]],
   [[|_| |_|___/ \___/ \_/ |_|_| |_| |_|]],
  },
  {
   [[neovim]]
  },
  {
   [[-. . --- ...- .. -- ]]
  },
  {
   [[#   # #####  ###  ####  #   # #   # ]],
   [[#   # #     #   # #   # #  ## ## ## ]],
   [[##### ####  #   # ####  # # # # # # ]],
   [[#   # #     #   # #   # ##  # #   # ]],
   [[#   # #####  ###  ####  #   # #   # ]]
  },
  {
   [[     __                   ]],
   [[| | |    >>  |  | > |\ /| ]],
   [[|\| |<< |  | |  | | | < | ]],
   [[| | |__  <<   \/  | |   | ]]
  },
  {
   [[ _  _____ ___  _________ _  _   _ ]],
   [[| |/ / __) _ \(  _____  ) || | | |]],
   [[| / /> _| (_) ) |_/ \_| | || |_| |]],
   [[|__/ \___)___/ \___^___/ \_) ._,_|]],
   [[                           | |    ]],
   [[                           |_|    ]]
  },
  {
   [[                                    oo            ]],
   [[88d888b. .d8888b. .d8888b. dP   .dP dP 88d8b.d8b. ]],
   [[88'  `88 88ooood8 88'  `88 88   d8' 88 88'`88'`88 ]],
   [[88    88 88.  ... 88.  .88 88 .88'  88 88  88  88 ]],
   [[dP    dP `88888P' `88888P' 8888P'   dP dP  dP  dP ]],
  },
  {
   [[                                    oo            ]],
   [[88d888b. .d8888b. .d8888b. dP   .dP dP 88d8b.d8b. ]],
   [[88'  `88 88ooood8 88'  `88 88   d8' 88 88'`88'`88 ]],
   [[88    88 88.  ... 88.  .88 88 .88'  88 88  88  88 ]],
   [[dP    dP `88888P' `88888P' 8888P'   dP dP  dP  dP ]],
   [[oooooooooooooooooooooooooooooooooooooooooooooooooo]],
  },
  {
   [[                                    oo            ]],
   [[88d888b. .d8888b. .d8888b. dP   .dP dP 88d8b.d8b. ]],
   [[88'  `88 88ooood8 88'  `88 88   d8' 88 88'`88'`88 ]],
   [[88    88 88.  ... 88.  .88 88 .88'  88 88  88  88 ]],
   [[dP    dP `88888P' `88888P' 8888P'   dP dP  dP  dP ]],
  },
  {
   [[_________________________________oo____________]],
   [[oo_ooo___ooooo___ooooo__oo____o______oo_oo_oo__]],
   [[ooo___o_oo____o_oo___oo_oo____o__oo__ooo_oo__o_]],
   [[oo____o_ooooooo_oo___oo_oo___o___oo__oo__oo__o_]],
   [[oo____o_oo______oo___oo__oo_o____oo__oo__oo__o_]],
   [[oo____o__ooooo___ooooo____oo____oooo_oo______o_]],
   [[_______________________________________________]]
  },
  {
   [[156 145 157 166 151 155 ]]
  },
  {
   [[#    # ######  ####  #    # # #    # ]],
   [[##   # #      #    # #    # # ##  ## ]],
   [[# #  # #####  #    # #    # # # ## # ]],
   [[#  # # #      #    # #    # # #    # ]],
   [[#   ## #      #    #  #  #  # #    # ]],
   [[#    # ######  ####    ##   # #    # ]]
  },
  {
   [[                            _            ]],
   [[ _       ____              (_)           ]],
   [[(_)__   (____) ___   _   _  _   __   __  ]],
   [[(____) (_)_(_)(___) (_) (_)(_) (__)_(__) ]],
   [[(_) (_)(__)__(_)_(_)(_)_(_)(_)(_) (_) (_)]],
   [[(_) (_) (____)(___)   (_)  (_)(_) (_) (_)]],
  },
  {
   [[                          o           ]],
   [['OoOo. .oOo. .oOo. `o   O O  `oOOoOO. ]],
   [[ o   O OooO' O   o  O   o o   O  o  o ]],
   [[ O   o O     o   O  o  O  O   o  O  O ]],
   [[ o   O `OoO' `OoO'  `o'   o'  O  o  o ]],
  },
  {
   [[ _  _  _    ._ _ ]],
   [[/ //_'/_/|/// / /]],
  },
  {
   [[                             _            ]],
   [[  ___     __     _    _   _ (_)  ___ ___  ]],
   [[/' _ `\ /'__`\ /'_`\ ( ) ( )| |/' _ ` _ `\]],
   [[| ( ) |(  ___/( (_) )| \_/ || || ( ) ( ) |]],
   [[(_) (_)`\____)`\___/'`\___/'(_)(_) (_) (_)]],
  },
  {
   [[  ^    ^    ^    ^    ^    ^  ]],
   [[ /n\  /e\  /o\  /v\  /i\  /m\ ]],
   [[<___><___><___><___><___><___>]]
  },
  {
   [[==========================================]],
   [[==========================================]],
   [[==========================================]],
   [[==========================================]],
   [[=  = ====   ====   ===  =  ==  ==  =  = ==]],
   [[=     ==  =  ==     ==  =  ======        =]],
   [[=  =  ==     ==  =  ===   ===  ==  =  =  =]],
   [[=  =  ==  =====  =  ===   ===  ==  =  =  =]],
   [[=  =  ==  =  ==  =  ==== ====  ==  =  =  =]],
   [[=  =  ===   ====   ===== ====  ==  =  =  =]],
   [[==========================================]]
  },
  {
   [[ __.   _    _    __       __  ]],
   [[ __)  (|)  (_)  <__  --o  __< ]],
  },
  {
   [[                        _       ]],
   [[                       (_)      ]],
   [[ ____  _____  ___ _   _ _ ____  ]],
   [[|  _ \| ___ |/ _ \ | | | |    \ ]],
   [[| | | | ____| |_| \ V /| | | | |]],
   [[|_| |_|_____)\___/ \_/ |_|_|_|_|]],
  },
  {
   [[]],
   [[]],
   [[]],
   [[]],
   [[]]
  },
  {
   [[ |  |\/| /\ |\  | |\/| ]],
   [[`|  |  | \/ | | | |/\| ]],
   [[ |` |  | /\ | | | |  | ]]
  },
  {
   [[ ____  _  __, _o ______ ]],
   [[/ / <_</_(_)\/<_/ / / <_]],
  },
  {
   [[                   o        ]],
   [[ _ _   _  __ _  ,_,  _ _ _  ]],
   [[/ / /_(/_(_)/ |/  (_/ / / /_]],
  },
  {
   [[                       o             ]],
   [[  _  _    _   __           _  _  _   ]],
   [[ / |/ |  |/  /  \_|  |_|  / |/ |/ |  ]],
   [[   |  |_/|__/\__/  \/  |_/  |  |  |_/]],
  },
  {
   [[ _  _  ___   __  _  _  __  __  __ ]],
   [[( \( )(  _) /  \( )( )(  )(  \/  )]],
   [[ )  (  ) _)( () )\\//  )(  )    ( ]],
   [[(_)\_)(___) \__/ (__) (__)(_/\/\_)]]
  },
  {
   [[                            _)            ]],
   [[  __ \    _ \   _ \ \ \   /  |  __ `__ \  ]],
   [[  |   |   __/  (   | \ \ /   |  |   |   | ]],
   [[ _|  _| \___| \___/   \_/   _| _|  _|  _| ]],
  },
  {
   [[                o       ]],
   [[;-. ,-. ,-. . , . ;-.-. ]],
   [[| | |-' | | |/  | | | | ]],
   [[' ' `-' `-' '   ' ' ' ' ]],
  },
  {
   [[,_ _     .,_ ]],
   [[||(/_()\/||||]],
  },
  {
   [[                    #|         ]],
   [[##H|  #H|  #H| ## H|   ##H H|  ]],
   [[## H|##HH|## H|## H|#| ### HH| ]],
   [[## H|##   ## H| #H| #| ## H H| ]],
   [[## H| #HH| #H|   #  #H|##   H| ]],
  },
  {
   [[ _  _   ___   ____   _   _   ___   _   _ ]],
   [[) \/ ( ) __( / __ \ \ ( ) / )_ _( ) \_/ (]],
   [[|  \ | | _)  ))__((  )\_/(  _| |_ |  _  |]],
   [[)_()_( )___( \____/   \_/  )_____()_( )_(]],
  },
  {
   [[ ____ ____ ____ ____ ____ ____ ]],
   [[||n |||e |||o |||v |||i |||m ||]],
   [[||__|||__|||__|||__|||__|||__||]],
   [[|/__\|/__\|/__\|/__\|/__\|/__\|]]
  },
  {
   [[        _  _       o         ]],
   [[ /|/|  |/ / \_|  |_| /|/|/|  ]],
   [[  | |_/|_/\_/  \/  |/ | | |_/]],
  },
  {
   [[                        _)        ]],
   [[    \    -_)   _ \ \ \ / |   ` \  ]],
   [[ _| _| \___| \___/  \_/ _| _|_|_| ]],
  },
  {
   [[ _ _  ,' c |_ _   '  _ _  ]],
   [[| ) )  | | |_)_)_ | |_)_) ]],
  },
  {
   [[                         _____            ]],
   [[_____________________   ____(_)______ ___ ]],
   [[__  __ \  _ \  __ \_ | / /_  /__  __ `__ \]],
   [[_  / / /  __/ /_/ /_ |/ /_  / _  / / / / /]],
   [[/_/ /_/\___/\____/_____/ /_/  /_/ /_/ /_/ ]],
  },
  {
   [[ _____  _____  _____  __ __  ___  __  __ ]],
   [[/  _  \/   __\/  _  \/  |  \/___\/  \/  \]],
   [[|  |  ||   __||  |  |\  |  /|   ||  \/  |]],
   [[\__|__/\_____/\_____/ \___/ \___/\__ \__/]],
  },
  {
   [[________________________ _________________]],
   [[7     77     77     77  V  77  77        7]],
   [[|  _  ||  ___!|  7  ||  |  ||  ||  _  _  |]],
   [[|  7  ||  __|_|  |  ||  !  ||  ||  7  7  |]],
   [[|  |  ||     7|  !  ||     ||  ||  |  |  |]],
   [[!__!__!!_____!!_____!!_____!!__!!__!__!__!]],
  },
  {
   [[,-. ,-. ,-. .  , . ,-,-. ]],
   [[| | |-' | | | /  | | | | ]],
   [[' ' `-' `-' `'   ' ' ' ' ]],
  },
  {
   [[,-. ,-. ,-. .  , . ,-,-. ]],
   [[| | |-' | | | /  | | | | ]],
   [[' ' `-' `-' `'   ' ' ' ' ]],
  },
  {
   [[ __  _ ___ __   _   _  _ __ __  ]],
   [[|  \| | __/__\ | \ / || |  V  | ]],
   [[| | ' | _| \/ |`\ V /'| | \_/ | ]],
   [[|_|\__|___\__/   \_/  |_|_| |_| ]]
  },
  {
   [[      ___  __               ]],
   [[|\ | |__  /  \ \  / |  |\/| ]],
   [[| \| |___ \__/  \/  |  |  | ]],
  },
  {
   [[                       _       ]],
   [[                      (_)      ]],
   [[ ____   ____ ___ _   _ _ ____  ]],
   [[|  _ \ / _  ) _ \ | | | |    \ ]],
   [[| | | ( (/ / |_| \ V /| | | | |]],
   [[|_| |_|\____)___/ \_/ |_|_|_|_|]],
  },
  {
   [[ _  _ _   . _  ]],
   [[| )(-(_)\/|||| ]],
  },
  {
   [[                   o          ]],
   [[.--. .-. .-..    ._.  .--.--. ]],
   [[|  |(.-'(   )\  /  |  |  |  | ]],
   [['  `-`--'`-'  `' -' `-'  '  `-]],
  },
  {
   [[                                 ##            ]],
   [[n)NNNN  e)EEEEE  o)OOO  v)    VV i)  m)MM MMM  ]],
   [[n)   NN e)EEEE  o)   OO  v)  VV  i) m)  MM  MM ]],
   [[n)   NN e)      o)   OO   v)VV   i) m)  MM  MM ]],
   [[n)   NN  e)EEEE  o)OOO     v)    i) m)      MM ]],
  },
  {
   [[neovim]]
  },
  {
   [[                         w           ]],
   [[8d8b. .d88b .d8b. Yb  dP w 8d8b.d8b. ]],
   [[8P Y8 8.dP' 8' .8  YbdP  8 8P Y8P Y8 ]],
   [[8   8 `Y88P `Y8P'   YP   8 8   8   8 ]],
  },
  {
   [[                     o     ]],
   [[,---.,---.,---..    ,.,-.-.]],
   [[|   ||---'|   | \  / || | |]],
   [[`   '`---'`---'  `'  `` ' ']],
  },
  {
   [[,  ,  _, _, ,   ,___, , , ]],
   [[|\ | /_,/ \,\  /' |  |\/| ]],
   [[|'\|'\_'\_/  \/` _|_,| `| ]],
   [['  `   `'    '  '    '  ` ]],
  },
  {
   [[ _  _  _   . _ _ ]],
   [[| |(/_(_)\/|| | |]],
  },
  {
   [[                   o       ]],
   [[o-o  o-o o-o o   o   o-O-o ]],
   [[|  | |-' | |  \ /  | | | | ]],
   [[o  o o-o o-o   o   | o o o ]],
  },
  {
   [[ _, _ __,  _, _,_ _ _, _]],
   [[ |\ | |_  / \ | / | |\/|]],
   [[ | \| |   \ / |/  | |  |]],
   [[ ~  ~ ~~~  ~  ~   ~ ~  ~]],
  },
  {
   [[     dBBBBb  dBBBP  dBBBBP dBP dP dBP dBBBBBBb]],
   [[        dBP        dBP.BP                  dBP]],
   [[   dBP dBP dBBP   dBP.BP dB .BP dBP dBPdBPdBP ]],
   [[  dBP dBP dBP    dBP.BP  BB.BP dBP dBPdBPdBP  ]],
   [[ dBP dBP dBBBBP dBBBBP   BBBP dBP dBPdBPdBP   ]],
  },
  {
   [[._  _ _   o._ _ ]],
   [[| |}_(_)\/|| | |]]
  },
  {
   [[ _   _   _     o  _ _  ]],
   [[) ) )_) (_) \) ( ) ) ) ]],
   [[   (_                  ]]
  },
  {
   [[                     /     ]],
   [[ ___  ___  ___         _ _ ]],
   [[|   )|___)|   ) \  )| | | )]],
   [[|  / |__  |__/   \/ | |  / ]],
  },
  {
   -- ][\][ ]E [[]] \/ ]][ ][\/][ 
   "][\\][ ]E [[]] \\/ ]][ ][\\/][ "
  }
}
return asciis
