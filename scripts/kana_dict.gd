extends RefCounted
#var hiragana_eng_vowels = [["あ", "a"], ["い", "i"], ["う", "u"], ["え", "e"], ["お", "o"]]
#var hiragana_eng_k_line = [["か", "ka"], ["き", "ki"], ["く", "ku"], ["け", "ke"], ["こ", "ko"]]
#var hiragana_eng_s_line = [["さ", "sa"], ["し", "shi"], ["す", "su"], ["せ", "se"], ["そ", "so"]]
#var hiragana_eng_t_line = [["た", "ta"], ["ち", "chi"], ["つ", "tsu"], ["て", "te"], ["と", "to"]]
#var hiragana_eng_n_line = [["な", "na"], ["に", "ni"], ["ぬ", "nu"], ["ね", "ne"], ["の", "no"]]
#var hiragana_eng_h_line = [["は", "ha"], ["ひ", "hi"], ["ふ", "fu"], ["へ", "he"], ["ほ", "ho"]]
#var hiragana_eng_m_line = [["ま", "ma"], ["み", "mi"], ["む", "mu"], ["め", "me"], ["も", "mo"]]
#var hiragana_eng_y_line = [["や", "ya"], ["ゆ", "yu"], ["よ", "yo"]]
#var hiragana_eng_r_line = [["ら", "ra"], ["り", "ri"], ["る", "ru"], ["れ", "re"], ["ろ", "ro"]]
#var hiragana_eng_w_line = [["わ", "wa"], ["を", "wo"],  ["ん", "n"]]

static var full_dict: Dictionary = {
	"a" : {"key" : "a", "hira" : "あ", "eng" : "a" , "kata" : "ア", "answer" : ["a"], "expl" : "a"}, 
	"i" : {"key" : "i", "hira" : "い", "eng" : "i" , "kata" : "イ", "answer" : ["i"], "expl" : "i"}, 
	"u" : {"key" : "u", "hira" : "う", "eng" : "u"  , "kata" : "ウ", "answer" : ["u"], "expl" : "u"},  
	"e" : {"key" : "e", "hira" : "え", "eng" : "e"  , "kata" : "エ", "answer" : ["e"], "expl" : "e"}, 
	"o" : {"key" : "o", "hira" : "お", "eng" : "o"  , "kata" : "オ", "answer" : ["o"], "expl" : "o"}, 
	"ka": {"key" : "ka", "hira" : "か", "eng" : "ka" , "kata" : "カ", "answer" : ["ka"], "expl" : "ka"},  
	"ki": {"key" : "ki", "hira" : "き", "eng" : "ki" , "kata" : "キ", "answer" : ["ki"], "expl" : "ki"},  
	"ku": {"key" : "ku", "hira" : "く", "eng" : "ku" , "kata" : "ク", "answer" : ["ku"], "expl" : "ku"}, 
	"ke": {"key" : "ke", "hira" : "け", "eng" : "ke" , "kata" : "ケ", "answer" : ["ke"], "expl" : "ke"}, 
	"ko": {"key" : "ko", "hira" : "こ", "eng" : "ko" , "kata" : "コ", "answer" : ["ko"], "expl" : "ko"},
	"sa": {"key" : "sa", "hira" : "さ", "eng" : "sa" , "kata" : "サ", "answer" : ["sa"], "expl" : "sa"},
	"shi":{"key" : "shi", "hira" : "し", "eng" : "shi", "kata" : "シ", "answer" : ["shi"], "expl" : "shi"},
	"su": {"key" : "su", "hira" : "す", "eng" : "su" , "kata" : "ス", "answer" : ["su"], "expl" : "su"},
	"se": {"key" : "se", "hira" : "せ", "eng" : "se" , "kata" : "セ", "answer" : ["se"], "expl" : "se"},
	"so": {"key" : "so", "hira" : "そ", "eng" : "so" , "kata" : "ソ", "answer" : ["so"], "expl" : "so"},
	"ta": {"key" : "ta", "hira" : "た", "eng" : "ta" , "kata" : "タ", "answer" : ["ta"], "expl" : "ta"},
	"chi":{"key" : "chi", "hira" : "ち", "eng" : "chi", "kata" : "チ", "answer" : ["chi"], "expl" : "chi"},
	"tsu":{"key" : "tsu", "hira" : "つ", "eng" : "tsu", "kata" : "ツ", "answer" : ["tsu"], "expl" : "tsu"},
	"te": {"key" : "te", "hira" : "て", "eng" : "te" , "kata" : "テ", "answer" : ["te"], "expl" : "te"},
	"to": {"key" : "to", "hira" : "と", "eng" : "to" , "kata" : "ト", "answer" : ["to"], "expl" : "to"},
	"na": {"key" : "na", "hira" : "な", "eng" : "na" , "kata" : "ナ", "answer" : ["na"], "expl" : "na"},
	"ni": {"key" : "ni", "hira" : "に", "eng" : "ni" , "kata" : "ニ", "answer" : ["ni"], "expl" : "ni"},
	"nu": {"key" : "nu", "hira" : "ぬ", "eng" : "nu" , "kata" : "ヌ", "answer" : ["nu"], "expl" : "nu"},
	"ne": {"key" : "ne", "hira" : "ね", "eng" : "ne" , "kata" : "ネ", "answer" : ["ne"], "expl" : "ne"},
	"no": {"key" : "no", "hira" : "の", "eng" : "no" , "kata" : "ノ", "answer" : ["no"], "expl" : "no"},
	"ha": {"key" : "ha", "hira" : "は", "eng" : "ha" , "kata" : "ハ", "answer" : ["ha"], "expl" : "ha ([wa] as a part.)"},
	"hi": {"key" : "hi", "hira" : "ひ", "eng" : "hi" , "kata" : "ヒ", "answer" : ["hi"], "expl" : "hi"},
	"fu": {"key" : "fu", "hira" : "ふ", "eng" : "fu" , "kata" : "フ", "answer" : ["fu"], "expl" : "fu"},
	"he": {"key" : "he", "hira" : "へ", "eng" : "he" , "kata" : "ヘ", "answer" : ["he"], "expl" : "he ([e] as a part.)"},
	"ho": {"key" : "ho", "hira" : "ほ", "eng" : "ho" , "kata" : "ホ", "answer" : ["ho"], "expl" : "ho"},
	"ma": {"key" : "ma", "hira" : "ま", "eng" : "ma" , "kata" : "マ", "answer" : ["ma"], "expl" : "ma"}, 
	"mi": {"key" : "mi", "hira" : "み", "eng" : "mi" , "kata" : "ミ", "answer" : ["mi"], "expl" : "mi"}, 
	"mu": {"key" : "mu", "hira" : "む", "eng" : "mu" , "kata" : "ム", "answer" : ["mu"], "expl" : "mu"}, 
	"me": {"key" : "me", "hira" : "め", "eng" : "me" , "kata" : "メ", "answer" : ["me"], "expl" : "me"}, 
	"mo": {"key" : "mo", "hira" : "も", "eng" : "mo" , "kata" : "モ", "answer" : ["mo"], "expl" : "mo"}, 
	"ya": {"key" : "ya", "hira" : "や", "eng" : "ya" , "kata" : "ヤ", "answer" : ["ya"], "expl" : "ya"}, 
	"yi": {"key" : "yi", "hira" : "", "eng" : "", "kata" : ""},
	"yu": {"key" : "yu", "hira" : "ゆ", "eng" : "yu" , "kata" : "ユ", "answer" : ["yu"], "expl" : "yu"}, 
	"ye": {"key" : "ye", "hira" : "", "eng" : "", "kata" : ""},
	"yo": {"key" : "yo", "hira" : "よ", "eng" : "yo" , "kata" : "ヨ", "answer" : ["yo"], "expl" : "yo"},
	"ra": {"key" : "ra", "hira" : "ら", "eng" : "ra" , "kata" : "ラ", "answer" : ["ra"], "expl" : "ra"}, 
	"ri": {"key" : "ri", "hira" : "り", "eng" : "ri" , "kata" : "リ", "answer" : ["ri"], "expl" : "ri"}, 
	"ru": {"key" : "ru", "hira" : "る", "eng" : "ru" , "kata" : "ル", "answer" : ["ru"], "expl" : "ru"}, 
	"re": {"key" : "re", "hira" : "れ", "eng" : "re" , "kata" : "レ", "answer" : ["re"], "expl" : "re"}, 
	"ro": {"key" : "ro", "hira" : "ろ", "eng" : "ro" , "kata" : "ロ", "answer" : ["ro"], "expl" : "ro"}, 
	"wa": {"key" : "wa", "hira" : "わ", "eng" : "wa" , "kata" : "ワ", "answer" : ["wa"], "expl" : "wa"},
	"wi": {"key" : "wi", "hira" : "", "eng" : "wi", "kata" : "ヰ", "answer" : ["wi"], "expl" : "wi (mostly obsolete)"},
	"wu": {"key" : "wu", "hira" : "", "eng" : "", "kata" : ""},
	"we": {"key" : "we", "hira" : "", "eng" : "(w)e", "kata" : "ヱ", "answer" : ["we"], "expl" : "w(e) (mostly obsolete)"},
	#"we": {"key" : "we", "hira" : "", "eng" : "[color=dark_gray]w[/color]e", "kata" : "ヱ", "answer" : ["we"], "expl" : "w(e) (mostly obsolete)"},
	"wo": {"key" : "wo", "hira" : "を", "eng" :  "(w)o", "kata" : "ヲ", "answer" : ["wo", "o"], "expl" : "(w)o"}, 
	#"wo": {"key" : "wo", "hira" : "を", "eng" :  "[color=dark_gray]w[/color]o", "kata" : "ヲ", "answer" : ["wo", "o"], "expl" : "(w)o"}, 
	"nk1": {"key" : "nk1", "hira" : "", "eng" : "", "kata" : ""},
	"nk2": {"key" : "nk2", "hira" : "", "eng" : "", "kata" : ""},
	"n": {"key" : "n", "hira" : "ん", "eng" :  "n", "kata" : "ン", "answer" : ["n"], "expl" : "n"}, 
	"nk3": {"key" : "nk3", "hira" : "", "eng" : "", "kata" : ""},
	"nk4": {"key" : "nk4", "hira" : "", "eng" : "", "kata" : ""},
} #  , "kata" : "", "answer" : [""], "expl" : ""}, 
#[color=gray]あ[/color]
