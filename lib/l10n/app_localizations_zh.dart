// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get registerTitle => '开启您的健康之旅';

  @override
  String get registerSubtitle => '创建账户以开始练习';

  @override
  String get stepPersonal => '个人信息';

  @override
  String get stepPreferences => '偏好设置';

  @override
  String get stepAccount => '账户设置';

  @override
  String get getToknowYou => '👋 让我们了解您';

  @override
  String get tellUsAbout => '请向我们介绍一下您自己';

  @override
  String get yourPreferences => '⚙️ 您的偏好';

  @override
  String get customizeYoga => '定制您的瑜伽体验';

  @override
  String get secureAccount => '🔐 保护您的账户';

  @override
  String get createCredentials => '创建您的登录凭据';

  @override
  String get passwordReqTitle => '密码要求：';

  @override
  String get reqLength => '至少 8 个字符';

  @override
  String get reqUpper => '1 个大写字母 (A-Z)';

  @override
  String get reqLower => '1 个小写字母 (a-z)';

  @override
  String get reqNumber => '1 个数字 (0-9)';

  @override
  String get reqSpecial => '1 个特殊字符 (!@#\$%...)';

  @override
  String get alreadyHaveAccount => '已经有账户？登录';

  @override
  String get back => '返回';

  @override
  String get createAccount => '创建账户';

  @override
  String get nameHint => '输入您的姓名';

  @override
  String get ageHint => '输入您的年龄';

  @override
  String get emailHint => 'your.email@example.com';

  @override
  String get passwordHint => '最少 8 位：包含大小写字母、数字和特殊字符';

  @override
  String get errEmailEmpty => '请输入您的电子邮箱';

  @override
  String get errEmailInvalid => '请输入有效的电子邮箱地址';

  @override
  String get errPasswordEmpty => '请输入密码';

  @override
  String get errNameEmpty => '请输入您的全名';

  @override
  String get errAgeEmpty => '请输入有效年龄（仅限数字）';

  @override
  String get errAgeRange => '请输入 1 到 120 之间的有效年龄';

  @override
  String get checkEmailMsg => '请检查您的邮箱以确认账户';

  @override
  String welcomeName(String name) {
    return '欢迎，$name! 🌿';
  }

  @override
  String get completeProfileTitle => '完善您的个人资料 🌸';

  @override
  String get completeProfileSubtitle => '只需几个快速细节即可个性化您的瑜伽之旅。';

  @override
  String get preferredLanguage => '首选语言';

  @override
  String get enterValidAge => '请输入有效年龄';

  @override
  String get profileCompleted => '资料已完善 🌿';

  @override
  String saveProfileFailed(String error) {
    return '保存资料失败：$error';
  }

  @override
  String get enableNotifications => '启用通知';

  @override
  String get continueButton => '继续';

  @override
  String get under18 => '18 岁以下';

  @override
  String ageRange(int start, int end) {
    return '$start-$end 岁';
  }

  @override
  String get welcomeBack => '欢迎回来 🧘‍♀️';

  @override
  String get loginSubtitle => '登录以继续您的疗愈之旅。';

  @override
  String get email => '电子邮箱';

  @override
  String get password => '密码';

  @override
  String get logIn => '登录';

  @override
  String get signInWithGoogle => '使用 Google 登录';

  @override
  String get dontHaveAccount => '还没有账户？注册';

  @override
  String get fillRequiredFields => '请填写所有必填字段';

  @override
  String get loginSuccess => '欢迎回来 🌿';

  @override
  String loginFailed(String error) {
    return '登录失败：$error';
  }

  @override
  String googleSignInFailed(String error) {
    return 'Google 登录失败：$error';
  }

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordTitle => 'Reset Your Password';

  @override
  String get resetPasswordSubtitle =>
      'Enter your email and we\'ll send you a reset link';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get resetLinkSent => 'Password reset link sent! Check your email 📧';

  @override
  String resetLinkFailed(String error) {
    return 'Failed to send reset link: $error';
  }

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get invalidCredentials =>
      'Invalid email or password. Please try again.';

  @override
  String get emailNotVerified =>
      'Please verify your email before logging in. Check your inbox.';

  @override
  String get accountNotFound =>
      'No account found with this email. Please register first.';

  @override
  String get tooManyAttempts =>
      'Too many login attempts. Please try again later.';

  @override
  String get networkError =>
      'Network error. Please check your connection and try again.';

  @override
  String get unknownError => 'An unexpected error occurred. Please try again.';

  @override
  String get emailAlreadyExists =>
      'This email is already registered. Please log in instead.';

  @override
  String get weakPassword =>
      'Password is too weak. Please follow the requirements.';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get onboardingHeading => '感受更强健的自己';

  @override
  String get onboardingDesc => '随时随地在家中或旅途中，\n向世界顶级的瑜伽教练学习。';

  @override
  String get letsExplore => '让我们开始探索';

  @override
  String get navHome => '首页';

  @override
  String get navSessions => '课程';

  @override
  String get navProgress => '进度';

  @override
  String get navMeditation => '冥想';

  @override
  String get navProfile => '个人中心';

  @override
  String get appTagline => '寻找内心的平静';

  @override
  String get goodMorning => '早上好！';

  @override
  String get goodAfternoon => '下午好！';

  @override
  String get goodEvening => '晚上好！';

  @override
  String get friend => '朋友';

  @override
  String get findYourPeace => '寻找内心的平静';

  @override
  String get calmingSounds => '为您的健康提供舒缓的声音';

  @override
  String get listenNow => '立即收听';

  @override
  String get yogaSubtitle => '非常适合刚开始瑜伽之旅的人';

  @override
  String get joinNow => '立即加入';

  @override
  String get wellnessOverview => '健康概览';

  @override
  String get haveANiceDay => '祝你今天愉快！';

  @override
  String get selectDate => '选择日期';

  @override
  String get todaysPractice => '今日练习';

  @override
  String get recommendedForYou => '为你推荐';

  @override
  String get seeAll => '查看全部';

  @override
  String get ambient => '环境音';

  @override
  String get streak => '连续天数';

  @override
  String get sessions => '练习次数';

  @override
  String get weekly => '本周';

  @override
  String get totalTime => '总时长';

  @override
  String daysCount(int count) {
    return '$count 天';
  }

  @override
  String minutesCount(int count) {
    return '$count 分钟';
  }

  @override
  String get beginYour => '开启您的';

  @override
  String get wellnessJourney => '健康之旅';

  @override
  String get beginnerSubtitle => '椅子瑜伽';

  @override
  String get beginnerDesc => '非常适合刚开始瑜伽之旅的人';

  @override
  String get intermediateSubtitle => '垫上哈他瑜伽';

  @override
  String get intermediateDesc => '通过挑战性的序列增强力量';

  @override
  String get advancedSubtitle => '动态流向日式';

  @override
  String get advancedDesc => '通过流动的序列挑战自我';

  @override
  String lockedLevelTitle(String levelName) {
    return '$levelName 已锁定';
  }

  @override
  String completeSessionsToUnlock(int count) {
    return '再完成 $count 个课程以解锁';
  }

  @override
  String get unlockIntermediateFirst => '请先解锁中级';

  @override
  String sessionsProgress(int current, int required) {
    return '$current / $required 课程';
  }

  @override
  String sessionsCompletedCount(int count) {
    return '已完成 $count 个课程';
  }

  @override
  String get errorLoadingProgress => '加载进度出错';

  @override
  String get retry => '重试';

  @override
  String get ok => '确定';

  @override
  String get enterPasscodeHint => '管理员密码 🔐';

  @override
  String get moreInfo => '更多信息';

  @override
  String get enterPinCode => '输入密码';

  @override
  String get pinInstructions => '请输入4位密码以观看视频';

  @override
  String get incorrectPin => '密码错误';

  @override
  String get backdoorAccess => '管理员访问';

  @override
  String get backdoorAdminMsg => '您拥有更改视频密码的管理员权限。';

  @override
  String get backdoorPathInstructions => '请前往 个人资料 > 设置 以更改密码。';

  @override
  String get beginnerTitle => '初级课程';

  @override
  String get warmup => '热身';

  @override
  String get mainPractice => '主练习';

  @override
  String get cooldown => '放松/冷却';

  @override
  String get viewDetails => '查看详情';

  @override
  String poseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个姿势',
      one: '1 个姿势',
    );
    return '$_temp0';
  }

  @override
  String sessionsCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已完成 $count 个课程',
      one: '已完成 1 个课程',
    );
    return '$_temp0';
  }

  @override
  String get intermediateTitle => '中级课程';

  @override
  String get hathaPractice => '哈他练习';

  @override
  String get startSession => '开始课程';

  @override
  String get advancedTitle => '高级课程';

  @override
  String get dynamicFlowNotice => '动态流练习。随呼吸而动。';

  @override
  String get advancedLabel => '高级';

  @override
  String get highIntensity => '高强度';

  @override
  String get sunSalutationTitle => '向日式流';

  @override
  String get repeatRounds => '重复 5-10 轮 • 一呼一吸，一个动作';

  @override
  String get beginFlow => '开始流动';

  @override
  String get step1 => '1. 下犬式';

  @override
  String get step2 => '2. 板式';

  @override
  String get step3 => '3. 八点式';

  @override
  String get step4 => '4. 眼镜蛇式（婴儿版）';

  @override
  String get step5 => '5. 眼镜蛇式（完整版）';

  @override
  String get step6 => '6. 回到下犬式';

  @override
  String get yogaHeadNeckShoulders => '头部、颈部与肩部伸展';

  @override
  String get yogaStraightArms => '直臂旋转';

  @override
  String get yogaBentArms => '屈臂旋转';

  @override
  String get yogaShouldersLateral => '肩膀侧向伸展';

  @override
  String get yogaShouldersTorsoTwist => '肩膀与躯干转体';

  @override
  String get yogaLegRaiseBent => '抬腿（屈膝）';

  @override
  String get yogaLegRaiseStraight => '抬腿（直膝）';

  @override
  String get yogaGoddessTwist => '女神式 — 躯干转体';

  @override
  String get yogaGoddessStrength => '女神式 — 腿部强化';

  @override
  String get yogaBackChestStretch => '背部与胸部伸展';

  @override
  String get yogaStandingCrunch => '站姿卷腹';

  @override
  String get yogaWarrior3Supported => '战士三式（有支撑）';

  @override
  String get yogaWarrior1Supported => '战士一式（有支撑）';

  @override
  String get yogaWarrior2Supported => '战士二式（有支撑）';

  @override
  String get yogaTriangleSupported => '三角式（有支撑）';

  @override
  String get yogaReverseWarrior2 => '反向战士二式';

  @override
  String get yogaSideAngleSupported => '侧角式（有支撑）';

  @override
  String get yogaGentleBreathing => '温和呼吸';

  @override
  String get yogaDownwardDog => '下犬式';

  @override
  String get yogaPlank => '板式 / 平板支撑';

  @override
  String get yogaEightPoint => '八点式';

  @override
  String get yogaBabyCobra => '小眼镜蛇式';

  @override
  String get yogaFullCobra => '眼镜蛇式';

  @override
  String get yogaSunSalutation => '拜日式流动';

  @override
  String get yogaSessionGentleChair => '温和椅子瑜伽';

  @override
  String get yogaSessionMorningMobility => '晨间灵活练习';

  @override
  String get yogaSessionWarriorSeries => '战士系列';

  @override
  String get yogaSessionHathaFundamentals => '哈达瑜伽基础';

  @override
  String get yogaSessionCoreStrength => '核心力量强化';

  @override
  String get yogaSessionBackbendFlow => '后弯流动';

  @override
  String get yogaSessionSunSalutation => '拜日式流动';

  @override
  String get yogaSessionExtendedFlow => '进阶流动练习';

  @override
  String get yogaDescHeadNeck => '温和的坐姿伸展，释放颈部和肩膀的紧张感。';

  @override
  String get yogaDescGentleChair =>
      '确保椅子稳定（可靠墙放置）。初级椅子瑜伽适合大多数人。建议空腹练习，或在餐后至少 2 小时进行。';

  @override
  String get yogaDescMorningMobility => '轻松的晨间练习，专注于关节灵活性、呼吸和有支撑的力量训练。';

  @override
  String get yogaDescWarriorSeries => '建立自信的序列，探索战士一式、二式及相关过渡动作。';

  @override
  String get yogaDescHathaFundamentals =>
      '经典的垫上哈达序列，专注于对齐、呼吸和全身参与。适合准备超越椅子支撑的练习者。';

  @override
  String get yogaDescCoreStrength => '短小精悍的课程，专注于板式、八点式和受控过渡。增强核心力量和肩膀稳定性。';

  @override
  String get yogaDescBackbendFlow => '强化脊椎的序列，从八点式过渡到小眼镜蛇式和眼镜蛇式。建立后弯的信心。';

  @override
  String get yogaDescSunSalutationSession =>
      '充满活力的垫上流动，旨在同步呼吸与动作。通过重复拜日式循环建立耐力和全身力量。';

  @override
  String get yogaDescExtendedFlow => '更深、更长的拜日式练习——适合希望在呼吸引导下挑战连续动作的经验丰富者。';

  @override
  String get yogaDescStraightArms => '手臂旋转以热身肩膀和上背部。';

  @override
  String get yogaDescBentArms => '屈肘的肩部灵活性练习。';

  @override
  String get yogaDescShouldersLateral => '改善灵活性的身体侧面伸展。';

  @override
  String get yogaDescShouldersTorsoTwist => '温和的排毒扭转动作。';

  @override
  String get yogaDescLegRaiseBent => '加强腿部力量并激活核心。';

  @override
  String get yogaDescLegRaiseStraight => '直腿抬高以进行进阶力量训练。';

  @override
  String get yogaDescGoddessTwist => '开胯坐姿以增进灵活性。';

  @override
  String get yogaDescGoddessStrength => '坐姿女神式的强化变体。';

  @override
  String get yogaDescBackChestStretch => 'L 型伸展以改善上半身灵活性。';

  @override
  String get yogaDescStandingCrunch => '动态核心强化动作。';

  @override
  String get yogaDescWarrior3Supported => '利用椅子支撑进行平衡与力量训练。';

  @override
  String get yogaDescWarrior1Supported => '适合初学者的战士站姿。';

  @override
  String get yogaDescWarrior2Supported => '面向侧边的战士式，用于打开髋关节。';

  @override
  String get yogaDescTriangleSupported => '深层侧身延伸。';

  @override
  String get yogaDescReverseWarrior2 => '后弯的战士式伸展。';

  @override
  String get yogaDescSideAngleSupported => '强化腿部并打开肋骨。';

  @override
  String get yogaDescGentleBreathing => '全身放紧与平静呼吸。';

  @override
  String get yogaDescDownwardDog => '基础的倒 V 姿势，伸展全身。';

  @override
  String get yogaDescPlank => '全身力量构建，参与核心、手臂和腿部。';

  @override
  String get yogaDescEightPoint => '强化力量的姿势，放下胸部、下巴、膝盖和脚趾。';

  @override
  String get yogaDescBabyCobra => '温和的后弯，强化上背部和脊柱。';

  @override
  String get yogaDescFullCobra => '更强的开胸后弯，全身参与。';

  @override
  String get yogaDescSunSalutation => '连接呼吸与动作的动态序列。建立力量、热量、协调性和耐力。';

  @override
  String get yogaInstHeadNeck =>
      '上下倾斜头部，各保持 5-10 次呼吸。转动头部左右各 3 圈。将耳朵靠向肩膀，可用手轻轻辅助。';

  @override
  String get yogaInstStraightArms => '握拳，直臂向前旋转 10 次，向后旋转 10 次。';

  @override
  String get yogaInstBentArms => '双肘在前方接触，向上绕过头后再向下。每个方向 10 圈。';

  @override
  String get yogaInstShouldersLateral => '右手垂向椅子，左臂向上举过头顶。保持 5-10 次呼吸，然后换边。';

  @override
  String get yogaInstShouldersTorsoTwist => '举起手臂，向右转动躯干，扶住椅子支撑。每侧保持 5-10 次呼吸。';

  @override
  String get yogaInstLegRaiseBent => '保持背部挺直，抬起弯曲的腿。保持后受控放下。换腿。';

  @override
  String get yogaInstLegRaiseStraight => '抬起伸直的腿，尽可能长时间保持。放松并换腿。';

  @override
  String get yogaInstGoddessTwist => '双膝张开，向侧面伸展躯干。保持 5-10 次呼吸，换边。';

  @override
  String get yogaInstGoddessStrength => '在女神式站姿中将大腿抬离椅子。保持 5-10 次呼吸。重复。';

  @override
  String get yogaInstBackChestStretch => '扶住椅子，铰链式下折呈 L 型，保持背部平坦。保持 5-10 次呼吸。';

  @override
  String get yogaInstStandingCrunch => '从 L 型开始，吸气时腿向后伸展，呼气时膝盖向前收缩。重复。';

  @override
  String get yogaInstWarrior3 => '手离开椅子，保持平衡。换腿并重复。';

  @override
  String get yogaInstWarrior1 => '向后迈步，弯曲前膝，举起双臂。保持 5-10 次呼吸。';

  @override
  String get yogaInstWarrior2 => '脚趾转向外侧，伸展手臂，看向前方。保持。';

  @override
  String get yogaInstTriangle => '伸直前腿，手向下触碰脚踝或瑜伽砖，另一手向上伸展。';

  @override
  String get yogaInstReverseWarrior => '向后倾斜时，上方手臂划过头顶。保持。';

  @override
  String get yogaInstSideAngle => '手降至脚内侧，上方手臂沿对角线向头顶上方延伸。';

  @override
  String get yogaInstGentleBreathing => '放松肩膀，双手放在大腿上，用鼻子缓慢呼吸。';

  @override
  String get yogaInstDownwardDog => '双手与肩同宽，双脚与髋同宽。抬高臀部，胸部向大腿方向下压。保持 5-10 次呼吸。';

  @override
  String get yogaInstPlank => '肩膀位于手腕正上方，收紧核心，身体从头到脚跟成一直线。保持 5-10 次呼吸。';

  @override
  String get yogaInstEightPoint => '从四足跪姿开始，放低胸部和下巴至垫上，臀部保持抬高。保持 5-10 次呼吸。';

  @override
  String get yogaInstBabyCobra => '俯卧，轻轻推起胸部，手肘夹紧身体，肩膀远离耳朵。保持 5-10 次呼吸。';

  @override
  String get yogaInstFullCobra => '伸直手肘，进一步抬高胸部，不要耸肩。保持 5-10 次呼吸。';

  @override
  String get yogaInstGentleBreathingIntermediate =>
      '双手放在腹部或大腿上，放松肩膀，用鼻子缓慢自然地呼吸。';

  @override
  String get yogaInstSunSalutation =>
      '此流动序列连续重复——一呼一吸配合一个动作。\n 1. 吸气 — 下犬式\n 抬高臀部，拉长脊柱。\n 2. 呼气 — 板式\n 向前移动进入强壮的板式位置。\n 3. 吸气 — 膝胸叩首（八点式）\n 受控下降，臀部抬高。\n 4. 呼气 — 小眼镜蛇式\n 轻轻抬起胸部，手肘靠近身体。\n 5. 吸气 — 眼镜蛇式\n 稍稍伸直手臂，打开胸腔。\n 6. 呼气 — 回到下犬式\n 向后压回倒 V 字型。\n 重复 5-10 轮或根据您的能力进行。';

  @override
  String get yogaGentleBreathingAdvanced => '通过鼻子柔和呼吸，拉长呼气。让全身沉静并放松。';

  @override
  String get yogaModMoveSlowly => '动作缓慢';

  @override
  String get yogaModStopDizzy => '若感到晕眩请停止';

  @override
  String get yogaModChairSupport => '使用椅背支撑';

  @override
  String get yogaModElbowsStraight => '保持手肘伸直';

  @override
  String get yogaModControlledMove => '动作平稳且受控';

  @override
  String get yogaModFingersShoulders => '手指保持在肩膀上';

  @override
  String get yogaModSlowRolls => '缓慢且受控地转动';

  @override
  String get yogaModButtocksDown => '保持臀部坐稳';

  @override
  String get yogaModFaceForward => '面向前方';

  @override
  String get yogaModHipsStable => '保持髋部稳定';

  @override
  String get yogaModShouldersLevel => '保持双肩齐平';

  @override
  String get yogaModBackStraight => '保持背部挺直';

  @override
  String get yogaModBeginBent => '从屈膝版本开始';

  @override
  String get yogaModUseChairForSupport => '使用椅子支撑';

  @override
  String get yogaModKneesToes => '膝盖与脚趾对齐';

  @override
  String get yogaModHipsGrounded => '保持臀部贴地/贴椅';

  @override
  String get yogaModTorsoUpright => '保持躯干挺直';

  @override
  String get yogaModChairBalance => '使用椅子保持平衡';

  @override
  String get yogaModArmsLegsStraight => '保持手臂和腿部伸直';

  @override
  String get yogaModEngageCore => '收紧核心';

  @override
  String get yogaModAvoidPregnancy => '怀孕期间请避免';

  @override
  String get yogaModOneHandChair => '保持一只手扶着椅子';

  @override
  String get yogaModStraightLine => '保持身体呈一直线';

  @override
  String get yogaModShortenStance => '缩短站距';

  @override
  String get yogaModSquareHips => '摆正髋部';

  @override
  String get yogaModLevelShoulders => '水平肩膀';

  @override
  String get yogaModUseBlock => '使用瑜伽砖';

  @override
  String get yogaModHipsForward => '保持髋部朝前';

  @override
  String get yogaModFrontKneeBent => '保持前膝弯曲';

  @override
  String get yogaModGazeDirection => '选择凝视方向';

  @override
  String get yogaModTuckTailbone => '轻微收尾骨';

  @override
  String get yogaModSitOrLieDown => '坐下或躺下';

  @override
  String get yogaModCloseEyesIfComfortable => '若感觉舒适可闭上眼睛';

  @override
  String get yogaModBendKnees => '若腿筋紧绷可弯曲膝盖';

  @override
  String get yogaModHeelsLifted => '练习时脚跟抬起';

  @override
  String get yogaModLowerKnees => '放下膝盖以进行温和版本';

  @override
  String get yogaModFeetTogether => '双脚并拢以增加挑战';

  @override
  String get yogaModSlowControl => '缓慢受控下降以保护肩膀';

  @override
  String get yogaModLiftPalms => '抬起手掌以增加挑战';

  @override
  String get yogaModPressFeet => '双脚向下踩实以增加稳定性';

  @override
  String get yogaModNoLockElbows => '不要锁死手肘';

  @override
  String get yogaModTuckStomach => '轻微收腹以支持脊柱';

  @override
  String get yogaModRestChildPose => '如有需要，在两轮之间于婴儿式休息';

  @override
  String get yogaModSlowTransitions => '如果呼吸变得吃力，请放慢过渡动作';

  @override
  String get yogaModBendDownwardDog => '在下犬式中弯曲膝盖以增加舒适感';

  @override
  String get yogaModSitOrLie => '坐直或平躺';

  @override
  String get yogaModCushionUnderKnees => '在膝盖下放置垫子';

  @override
  String get sessionLevelLabel => '难度等级';

  @override
  String get sessionTotalTimeLabel => '总时长';

  @override
  String get sessionTotalPosesLabel => '总姿势数';

  @override
  String get aboutThisSession => '课程简介';

  @override
  String get posesPreview => '姿势预览';

  @override
  String posesCompletedCount(int completed, int total) {
    return '已完成 $completed / $total 个姿势';
  }

  @override
  String get practiceAgain => '再次练习';

  @override
  String get posesLabel => '个姿势';

  @override
  String get duration => '时长';

  @override
  String get poses => '姿势';

  @override
  String get intensity => '强度';

  @override
  String get low => '低';

  @override
  String get aboutSession => '关于课程';

  @override
  String get sessionOverview => '课程概览';

  @override
  String get joinClass => '参加课程';

  @override
  String dayNumber(int number) {
    return '第 $number 天';
  }

  @override
  String minsLabel(int count) {
    return '$count 分钟';
  }

  @override
  String get completeCurrentPoseFirst => '请先完成当前的动作！';

  @override
  String get poseComplete => '动作完成！';

  @override
  String get greatWorkChoice => '做得好！接下来您想做什么？';

  @override
  String get retryPose => '再做一次';

  @override
  String get nextPose => '下一个姿势';

  @override
  String get finishSession => '结束课程';

  @override
  String get sessionComplete => '课程完成！';

  @override
  String completedPoses(int count) {
    return '已完成 $count 个动作';
  }

  @override
  String totalMinutesSpent(int value, String unit) {
    return '您已练习了 $value $unit';
  }

  @override
  String get totaltime => '总练习时长：';

  @override
  String get howToPose => '动作指南';

  @override
  String get sessionPlaylist => '课程列表';

  @override
  String get playing => '播放中';

  @override
  String get pause => '暂停';

  @override
  String get resume => '继续';

  @override
  String get waitingForPin => '等待输入密码...';

  @override
  String get exitSessionTitle => '退出练习？';

  @override
  String posesCompletedInfo(int completed, int total) {
    return '已完成 $completed / $total 个动作';
  }

  @override
  String get progressSaved => '进度已保存 ✓';

  @override
  String get continueLater => '您可以随时回来继续练习！';

  @override
  String get noPosesCompleted => '尚未完成任何动作';

  @override
  String get completeOneToSave => '请至少完成一个动作以保存您的进度。';

  @override
  String get stayButton => '继续练习';

  @override
  String get playbackNormal => '正常';

  @override
  String poseProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get videoTutorial => '视频教程';

  @override
  String get safetyTips => '安全提示';

  @override
  String get tip1 => '保持膝盖微屈以避免关节受压';

  @override
  String get tip2 => '在整个姿势中收紧核心肌肉';

  @override
  String get tip3 => '不要强迫脚后跟触地';

  @override
  String get tip4 => '深呼吸，避免屏息';

  @override
  String get tip5 => '如果感到疼痛，请缓慢退出姿势';

  @override
  String get markAsCompleted => '标记为已完成';

  @override
  String get completed => '已完成';

  @override
  String get poseMarkedSuccess => '姿势已标记为完成！';

  @override
  String get completeSession => '完成课程';

  @override
  String get congratulations => '🎉 恭喜！';

  @override
  String get sessionCompleteDesc => '您已完成本课程中的所有姿势！';

  @override
  String get done => '完成';

  @override
  String get poseDetailTitle => '姿势详情';

  @override
  String get howToDoTitle => '动作要领';

  @override
  String get learningNotice => '此处仅供学习参考。如需记录进度，请从课程界面点击“加入课程”。';

  @override
  String poseCurrentCount(int current, int total) {
    return '第 $current / $total 个';
  }

  @override
  String durationFormat(int minutes, String seconds) {
    return '$minutes:$seconds 分钟';
  }

  @override
  String get calendar => '练习日历';

  @override
  String get activitySummary => '活动摘要';

  @override
  String get totalMinutes => '总分钟数';

  @override
  String get thisWeek => '本周进度';

  @override
  String get dailyMinutes => '每日时长';

  @override
  String get week => '周';

  @override
  String get nothingTracked => '暂无记录';

  @override
  String get min => '分钟';

  @override
  String ofGoal(int goal) {
    return '目标 $goal 分钟';
  }

  @override
  String get weeklyBadges => '每周勋章';

  @override
  String get wellnessCheckIn => '健康打卡';

  @override
  String get checkedInThisWeek => '本周已打卡 ✓';

  @override
  String get howAreYouFeeling => '您今天感觉如何？';

  @override
  String get checkInButton => '开始打卡';

  @override
  String get historyButton => '查看历史';

  @override
  String get practice => '练习日';

  @override
  String get restDay => '休息日';

  @override
  String get reflectionHistory => '感悟历史';

  @override
  String get noReflections => '暂无感悟记录';

  @override
  String get bodyComfort => '身体舒适度';

  @override
  String get flexibility => '灵活性';

  @override
  String get balance => '平衡力';

  @override
  String get energy => '精力水平';

  @override
  String get mood => '情绪状态';

  @override
  String get confidence => '日常自信心';

  @override
  String get mindBody => '身心连接';

  @override
  String get wellbeing => '整体健康';

  @override
  String get notes => '备注：';

  @override
  String get wellnessDialogTitle => '健康打卡';

  @override
  String get wellnessDialogSubtitle => '请评估您过去一周的感受';

  @override
  String get qBodyComfort => '练习时身体感到舒适吗？';

  @override
  String get qFlexibility => '您觉得最近身体变灵活了吗？';

  @override
  String get qBalance => '平衡动作练习得稳吗？';

  @override
  String get qEnergy => '您的精力水平如何？';

  @override
  String get qMood => '最近心情怎么样？';

  @override
  String get qConfidence => '日常生活中感到自信吗？';

  @override
  String get qBodyConnection => '练习时能感受到身心连接吗？';

  @override
  String get qOverall => '总体而言，您对目前的健康状况满意吗？';

  @override
  String get notesOptional => '备注（选填）';

  @override
  String get cancel => '取消';

  @override
  String get submit => '提交';

  @override
  String get rateAllError => '请评价所有项目后再提交';

  @override
  String get checkInSaved => '健康打卡已保存！';

  @override
  String get platinum => '铂金';

  @override
  String get gold => '黄金';

  @override
  String get silver => '白银';

  @override
  String get bronze => '青铜';

  @override
  String get none => '无';

  @override
  String get section1Title => '第一部分 – 身体舒适度与灵活性';

  @override
  String get section2Title => '第二部分 – 精力与情绪';

  @override
  String get section3Title => '第三部分 – 觉知与自信';

  @override
  String get section4Title => '⭐ 整体健康';

  @override
  String get qBodyComfortFull => '1️⃣ 运动时身体感觉有多舒适？';

  @override
  String get optComfort1 => '不舒适';

  @override
  String get optComfort2 => '略微舒适';

  @override
  String get optComfort3 => '中度舒适';

  @override
  String get optComfort4 => '非常舒适';

  @override
  String get optComfort5 => '极其舒适';

  @override
  String get qFlexibilityFull => '2️⃣ 您如何描述最近的灵活性？';

  @override
  String get optFlexibility1 => '僵硬得多';

  @override
  String get optFlexibility2 => '有点僵硬';

  @override
  String get optFlexibility3 => '差不多';

  @override
  String get optFlexibility4 => '更有弹性了';

  @override
  String get optFlexibility5 => '灵活得多';

  @override
  String get qBalanceFull => '3️⃣ 站立或平衡时感觉稳吗？';

  @override
  String get optBalance1 => '一点也不稳';

  @override
  String get optBalance2 => '略微稳当';

  @override
  String get optBalance3 => '中度稳当';

  @override
  String get optBalance4 => '非常稳当';

  @override
  String get optBalance5 => '极其稳当';

  @override
  String get qEnergyFull => '4️⃣ 您的整体精力水平如何？';

  @override
  String get optEnergy1 => '非常低';

  @override
  String get optEnergy2 => '低';

  @override
  String get optEnergy3 => '一般';

  @override
  String get optEnergy4 => '良好';

  @override
  String get optEnergy5 => '非常好';

  @override
  String get qMoodFull => '5️⃣ 最近的心情怎么样？';

  @override
  String get optMood1 => '经常感到压力或沮丧';

  @override
  String get optMood2 => '有时感到压力';

  @override
  String get optMood3 => '大多还好';

  @override
  String get optMood4 => '大多积极';

  @override
  String get optMood5 => '非常积极和平静';

  @override
  String get qConfidenceFull => '6️⃣ 进行日常活动时感觉有多自信？';

  @override
  String get optConfidence1 => '不自信';

  @override
  String get optConfidence2 => '略微自信';

  @override
  String get optConfidence3 => '有些自信';

  @override
  String get optConfidence4 => '自信';

  @override
  String get optConfidence5 => '非常自信';

  @override
  String get qBodyConnectionFull => '7️⃣ 练习瑜伽时与身体的连接感如何？';

  @override
  String get optConnection1 => '没有连接感';

  @override
  String get optConnection2 => '有一点连接感';

  @override
  String get optConnection3 => '中度连接感';

  @override
  String get optConnection4 => '非常有连接感';

  @override
  String get optConnection5 => '深度连接';

  @override
  String get qOverallFull => '8️⃣ 总体而言，您如何评价本月的健康状况？';

  @override
  String get optOverall1 => '较差';

  @override
  String get optOverall2 => '一般';

  @override
  String get optOverall3 => '好';

  @override
  String get optOverall4 => '非常好';

  @override
  String get optOverall5 => '极好';

  @override
  String get monthlyReflections => '💭 每月感悟（选填）';

  @override
  String get shareImprovements => '分享您注意到的具体进步：';

  @override
  String get labelBalance => '🧘 平衡力提升';

  @override
  String get hintBalance => '例如：我可以单脚站立更久了...';

  @override
  String get labelPosture => '🪑 体态改善';

  @override
  String get hintPosture => '例如：我的背感觉更直了...';

  @override
  String get labelConsistency => '📅 坚持与习惯';

  @override
  String get hintConsistency => '例如：我现在每天早上都练习...';

  @override
  String get labelOther => '💬 其他想法';

  @override
  String get hintOther => '任何其他进步或笔记...';

  @override
  String get skipForNow => '暂时跳过';

  @override
  String get submitCheckIn => '提交打卡';

  @override
  String get validationErrorCheckIn => '提交前请回答所有必填问题';

  @override
  String get nowPlaying => '正在播放';

  @override
  String get moreDetails => '更多详情';

  @override
  String get aboutThisSound => '关于此声音';

  @override
  String get category => '类别';

  @override
  String get type => '类型';

  @override
  String get meditationType => '冥想与放松';

  @override
  String get benefits => '益处';

  @override
  String get soundBenefit1 => '• 减轻压力和焦虑';

  @override
  String get soundBenefit2 => '• 提高注意力和专注力';

  @override
  String get soundBenefit3 => '• 促进更好的睡眠';

  @override
  String get soundBenefit4 => '• 提升整体幸福感';

  @override
  String get meditationHeader => '冥想与白噪音';

  @override
  String get quickStart => '快速开始';

  @override
  String get guidedMeditationSection => '引导式冥想';

  @override
  String get ambientSoundsSection => '大自然的声音';

  @override
  String get ambientSoundsSubtitle => '纯净的大自然声音助您放松';

  @override
  String get morningClarityTitle => '晨间清爽';

  @override
  String get morningClarityDesc => '开启充满宁静与力量的一天';

  @override
  String get deepBreathingTitle => '深呼吸练习';

  @override
  String get deepBreathingDesc => '通过专注呼吸缓解压力';

  @override
  String get eveningWindDownTitle => '晚间放松';

  @override
  String get eveningWindDownDesc => '卸下疲惫，准备进入梦乡';

  @override
  String get oceanWavesTitle => '海浪声';

  @override
  String get oceanWavesDesc => '海浪拍打沙滩的柔和声';

  @override
  String get rainSoundsTitle => '雨声';

  @override
  String get rainSoundsDesc => '淅沥的雨声与闷雷';

  @override
  String get forestBirdsTitle => '森林鸟鸣';

  @override
  String get forestBirdsDesc => '置身于大自然的鸟语花香';

  @override
  String get cracklingFireTitle => '木柴燃烧声';

  @override
  String get cracklingFireDesc => '壁炉火堆的温暖声';

  @override
  String get whiteNoiseTitle => '白噪音';

  @override
  String get whiteNoiseDesc => '纯净白噪音，助力专注';

  @override
  String get flowingWaterTitle => '流水潺潺';

  @override
  String get flowingWaterDesc => '溪水流过的清脆声';

  @override
  String get windChimesTitle => '清脆风铃';

  @override
  String get windChimesDesc => '宁静祥和的风铃声';

  @override
  String get nightCricketsTitle => '夏夜虫鸣';

  @override
  String get nightCricketsDesc => '宁静夜晚的蛐蛐叫声';

  @override
  String get meditationHeaderTitle => '选择您的冥想课程';

  @override
  String get meditationHeaderSubtitle => '停下来，深呼吸';

  @override
  String get meditationQuickStart => '快速开始 • 5-10 分钟';

  @override
  String get meditationAllSection => '所有冥想';

  @override
  String get meditationCategoryLabel => '冥想';

  @override
  String meditationDurationMin(int count) {
    return '$count 分钟';
  }

  @override
  String get meditationSessionMorningTitle => '晨间清透';

  @override
  String get meditationSessionMorningDesc => '以平和的心境开启新的一天';

  @override
  String get meditationSessionBreathingTitle => '深呼吸练习';

  @override
  String get meditationSessionBreathingDesc => '通过专注呼吸缓解压力';

  @override
  String get meditationSessionEveningTitle => '睡前放松';

  @override
  String get meditationSessionEveningDesc => '放下疲惫，为休息做好准备';

  @override
  String get soundCategory => '环境音';

  @override
  String get meditationPreparing => '正在为您准备课程...';

  @override
  String get meditationCancel => '取消课程';

  @override
  String get meditationEndSession => '结束课程';

  @override
  String get meditationComplete => '课程已完成';

  @override
  String get meditationInhale => '吸气...';

  @override
  String get meditationExhale => '呼气...';

  @override
  String get meditationHold => '屏息...';

  @override
  String get meditationEndTitle => '结束课程？';

  @override
  String get meditationEndMessage => '您确定要结束当前的冥想课程吗？';

  @override
  String get meditationConfirmEnd => '结束';

  @override
  String get profileTitle => '个人中心';

  @override
  String get edit => '编辑';

  @override
  String get minutesLabel => '分钟';

  @override
  String get daily => '每日 🔥';

  @override
  String get streakSummary => '连续天数总结';

  @override
  String get weeklyActive => '每周活跃周数';

  @override
  String get preferences => '偏好设置';

  @override
  String get enabled => '已启用';

  @override
  String get disabled => '已禁用';

  @override
  String get signout => '登出';

  @override
  String get aboutus => '关于我们';

  @override
  String get editProfile => '编辑个人资料';

  @override
  String get save => '保存';

  @override
  String get uploadPhoto => '上传照片';

  @override
  String get removePhoto => '移除照片';

  @override
  String get photoUpdated => '头像已更新';

  @override
  String get photoRemoved => '头像已移除';

  @override
  String get photoFail => '上传失败';

  @override
  String get basicInfo => '基本信息';

  @override
  String get fullName => '全名';

  @override
  String get age => '年龄';

  @override
  String get experienceLevel => '经验等级';

  @override
  String get sessionLength => '课程时长';

  @override
  String get language => '语言';

  @override
  String get notifications => '通知';

  @override
  String get pushNotifications => '推送通知';

  @override
  String get pushEnabledMsg => '推送通知已启用！🔔';

  @override
  String get dailyReminder => '每日练习提醒';

  @override
  String get dailyReminderEnabled => '每日提醒已启用！';

  @override
  String get dailyEnabledMsg => '我们每天都会提醒您练习。🌞';

  @override
  String get reminderTime => '提醒时间';

  @override
  String get dailyReminderNotification => '每日练习提醒';

  @override
  String get dailyReminderBody => '该做每日瑜伽练习了！🏃‍♀️';

  @override
  String get sound => '声音';

  @override
  String get soundEffects => '音效';

  @override
  String get appVolume => '应用音量';

  @override
  String get systemVolume => '系统音量';

  @override
  String get appVolumeDesc => '调整应用内声音的音量';

  @override
  String get systemVolumeDesc => '调整您的设备系统音量';

  @override
  String get validationError => '姓名和年龄为必填项';

  @override
  String get beginner => '初学者';

  @override
  String get intermediate => '中级';

  @override
  String get advanced => '高级';

  @override
  String get min5 => '5 分钟';

  @override
  String get min10 => '10 分钟';

  @override
  String get min15 => '15 分钟';

  @override
  String get min20 => '20 分钟';

  @override
  String get min30 => '30 分钟';

  @override
  String get english => '英文';

  @override
  String get mandarinSimplified => '简体中文';

  @override
  String get mandarinTraditional => '繁体中文';

  @override
  String completedPosesCount(int count) {
    return '您完成了 $count 个姿势！';
  }

  @override
  String get minutes => '分钟';

  @override
  String get next => '下一步';

  @override
  String get aboutThisPose => '关于此姿势';

  @override
  String get exitSession => '退出课程？';

  @override
  String get exitSessionMessage => '如果现在退出，您的进度将不会被保存。确定要退出吗？';

  @override
  String get exit => '退出';

  @override
  String get aboutUsTitle => '关于我们';

  @override
  String get appName => 'Zencore';

  @override
  String get appVersion => '版本 1.0.0';

  @override
  String get ourMission => '我们的使命';

  @override
  String get missionStatement => '通过温和的椅子瑜伽、舒缓的冥想和正念练习，让每个人都能享受健康生活。';

  @override
  String get projectTeam => '项目团队';

  @override
  String get projectSupervisor => '项目主管';

  @override
  String get developmentTeam => '开发团队';

  @override
  String get yogaInstructor => '瑜伽导师';

  @override
  String get keyFeatures => '核心功能';

  @override
  String get featureChairYoga => '椅子瑜伽课程';

  @override
  String get featureMeditation => '专业冥想指导';

  @override
  String get featureProgress => '进度跟踪';

  @override
  String get featureSounds => '助眠舒缓音效';

  @override
  String get licensesTitle => '开源许可';

  @override
  String get licenseDescription => 'HealYoga 是使用開源軟體構建的。您可以在下方查看完整的許可列表。';

  @override
  String get viewLicensesButton => '查看所有许可';

  @override
  String get copyright => '© 2026 ZENCORE';

  @override
  String get allRightsReserved => '保留所有权利';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get registerTitle => '开启您的健康之旅';

  @override
  String get registerSubtitle => '创建账户以开始练习';

  @override
  String get stepPersonal => '个人信息';

  @override
  String get stepPreferences => '偏好设置';

  @override
  String get stepAccount => '账户设置';

  @override
  String get getToknowYou => '👋 让我们了解您';

  @override
  String get tellUsAbout => '请向我们介绍一下您自己';

  @override
  String get yourPreferences => '⚙️ 您的偏好';

  @override
  String get customizeYoga => '定制您的瑜伽体验';

  @override
  String get secureAccount => '🔐 保护您的账户';

  @override
  String get createCredentials => '创建您的登录凭据';

  @override
  String get passwordReqTitle => '密码要求：';

  @override
  String get reqLength => '至少 8 个字符';

  @override
  String get reqUpper => '1 个大写字母 (A-Z)';

  @override
  String get reqLower => '1 个小写字母 (a-z)';

  @override
  String get reqNumber => '1 个数字 (0-9)';

  @override
  String get reqSpecial => '1 个特殊字符 (!@#\$%...)';

  @override
  String get alreadyHaveAccount => '已经有账户？登录';

  @override
  String get back => '返回';

  @override
  String get createAccount => '创建账户';

  @override
  String get nameHint => '输入您的姓名';

  @override
  String get ageHint => '输入您的年龄';

  @override
  String get emailHint => 'your.email@example.com';

  @override
  String get passwordHint => '最少 8 位：包含大小写字母、数字和特殊字符';

  @override
  String get errEmailEmpty => '请输入您的电子邮箱';

  @override
  String get errEmailInvalid => '请输入有效的电子邮箱地址';

  @override
  String get errPasswordEmpty => '请输入密码';

  @override
  String get errNameEmpty => '请输入您的全名';

  @override
  String get errAgeEmpty => '请输入有效年龄（仅限数字）';

  @override
  String get errAgeRange => '请输入 1 到 120 之间的有效年龄';

  @override
  String get checkEmailMsg => '请检查您的邮箱以确认账户';

  @override
  String welcomeName(String name) {
    return '欢迎，$name! 🌿';
  }

  @override
  String get completeProfileTitle => '完善您的个人资料 🌸';

  @override
  String get completeProfileSubtitle => '只需几个快速细节即可个性化您的瑜伽之旅。';

  @override
  String get preferredLanguage => '首选语言';

  @override
  String get enterValidAge => '请输入有效年龄';

  @override
  String get profileCompleted => '资料已完善 🌿';

  @override
  String saveProfileFailed(String error) {
    return '保存资料失败：$error';
  }

  @override
  String get enableNotifications => '启用通知';

  @override
  String get continueButton => '继续';

  @override
  String get under18 => '18 岁以下';

  @override
  String ageRange(int start, int end) {
    return '$start-$end 岁';
  }

  @override
  String get welcomeBack => '欢迎回来 🧘‍♀️';

  @override
  String get loginSubtitle => '登录以继续您的疗愈之旅。';

  @override
  String get email => '电子邮箱';

  @override
  String get password => '密码';

  @override
  String get logIn => '登录';

  @override
  String get signInWithGoogle => '使用 Google 登录';

  @override
  String get dontHaveAccount => '还没有账户？注册';

  @override
  String get fillRequiredFields => '请填写所有必填字段';

  @override
  String get loginSuccess => '欢迎回来 🌿';

  @override
  String loginFailed(String error) {
    return '登录失败：$error';
  }

  @override
  String googleSignInFailed(String error) {
    return 'Google 登录失败：$error';
  }

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get resetPassword => '重置密码';

  @override
  String get resetPasswordTitle => '重置您的密码';

  @override
  String get resetPasswordSubtitle => '输入您的电子邮箱，我们将向您发送重置链接';

  @override
  String get sendResetLink => '发送重置链接';

  @override
  String get resetLinkSent => '密码重置链接已发送！请检查您的电子邮箱 📧';

  @override
  String resetLinkFailed(String error) {
    return '发送重置链接失败：$error';
  }

  @override
  String get backToLogin => '返回登录';

  @override
  String get invalidCredentials => '电子邮箱或密码无效。请重试。';

  @override
  String get emailNotVerified => '请在登录前验证您的电子邮箱。请检查您的收件箱。';

  @override
  String get accountNotFound => '未找到该电子邮箱的账户。请先注册。';

  @override
  String get tooManyAttempts => '登录尝试次数过多。请稍后重试。';

  @override
  String get networkError => '网络错误。请检查您的连接后重试。';

  @override
  String get unknownError => '发生意外错误。请重试。';

  @override
  String get emailAlreadyExists => '该电子邮箱已注册。请改用登录。';

  @override
  String get weakPassword => '密码太弱。请遵循要求。';

  @override
  String get changeLanguage => '更改语言';

  @override
  String get onboardingHeading => '感受更强健的自己';

  @override
  String get onboardingDesc => '随时随地在家中或旅途中，\n向世界顶级的瑜伽教练学习。';

  @override
  String get letsExplore => '让我们开始探索';

  @override
  String get navHome => '首页';

  @override
  String get navSessions => '课程';

  @override
  String get navProgress => '进度';

  @override
  String get navMeditation => '冥想';

  @override
  String get navProfile => '个人中心';

  @override
  String get appTagline => '寻找内心的平静';

  @override
  String get goodMorning => '早上好！';

  @override
  String get goodAfternoon => '下午好！';

  @override
  String get goodEvening => '晚上好！';

  @override
  String get friend => '朋友';

  @override
  String get findYourPeace => '寻找内心的平静';

  @override
  String get calmingSounds => '为您的健康提供舒缓的声音';

  @override
  String get listenNow => '立即收听';

  @override
  String get yogaSubtitle => '非常适合刚开始瑜伽之旅的人';

  @override
  String get joinNow => '立即加入';

  @override
  String get wellnessOverview => '健康概览';

  @override
  String get haveANiceDay => '祝你今天愉快！';

  @override
  String get selectDate => '选择日期';

  @override
  String get todaysPractice => '今日练习';

  @override
  String get recommendedForYou => '为你推荐';

  @override
  String get seeAll => '查看全部';

  @override
  String get ambient => '环境音';

  @override
  String get streak => '连续天数';

  @override
  String get sessions => '练习次数';

  @override
  String get weekly => '本周';

  @override
  String get totalTime => '总时长';

  @override
  String daysCount(int count) {
    return '$count 天';
  }

  @override
  String minutesCount(int count) {
    return '$count 分钟';
  }

  @override
  String get beginYour => '开启您的';

  @override
  String get wellnessJourney => '健康之旅';

  @override
  String get beginnerSubtitle => '椅子瑜伽';

  @override
  String get beginnerDesc => '非常适合刚开始瑜伽之旅的人';

  @override
  String get intermediateSubtitle => '垫上哈他瑜伽';

  @override
  String get intermediateDesc => '通过挑战性的序列增强力量';

  @override
  String get advancedSubtitle => '动态流向日式';

  @override
  String get advancedDesc => '通过流动的序列挑战自我';

  @override
  String lockedLevelTitle(String levelName) {
    return '$levelName 已锁定';
  }

  @override
  String completeSessionsToUnlock(int count) {
    return '再完成 $count 个课程以解锁';
  }

  @override
  String get unlockIntermediateFirst => '请先解锁中级';

  @override
  String sessionsProgress(int current, int required) {
    return '$current / $required 课程';
  }

  @override
  String sessionsCompletedCount(int count) {
    return '已完成 $count 个课程';
  }

  @override
  String get errorLoadingProgress => '加载进度出错';

  @override
  String get retry => '重试';

  @override
  String get ok => '确定';

  @override
  String get enterPasscodeHint => '管理员密码 🔐';

  @override
  String get moreInfo => '更多信息';

  @override
  String get enterPinCode => '输入密码';

  @override
  String get pinInstructions => '请输入4位密码以观看视频';

  @override
  String get incorrectPin => '密码错误';

  @override
  String get backdoorAccess => '管理员访问';

  @override
  String get backdoorAdminMsg => '您拥有更改视频密码的管理员权限。';

  @override
  String get backdoorPathInstructions => '请前往 个人资料 > 设置 以更改密码。';

  @override
  String get beginnerTitle => '初级课程';

  @override
  String get warmup => '热身';

  @override
  String get mainPractice => '主练习';

  @override
  String get cooldown => '放松/冷却';

  @override
  String get viewDetails => '查看详情';

  @override
  String poseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个姿势',
      one: '1 个姿势',
    );
    return '$_temp0';
  }

  @override
  String sessionsCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已完成 $count 个课程',
      one: '已完成 1 个课程',
    );
    return '$_temp0';
  }

  @override
  String get intermediateTitle => '中级课程';

  @override
  String get hathaPractice => '哈他练习';

  @override
  String get startSession => '开始课程';

  @override
  String get advancedTitle => '高级课程';

  @override
  String get dynamicFlowNotice => '动态流练习。随呼吸而动。';

  @override
  String get advancedLabel => '高级';

  @override
  String get highIntensity => '高强度';

  @override
  String get sunSalutationTitle => '向日式流';

  @override
  String get repeatRounds => '重复 5-10 轮 • 一呼一吸，一个动作';

  @override
  String get beginFlow => '开始流动';

  @override
  String get step1 => '1. 下犬式';

  @override
  String get step2 => '2. 板式';

  @override
  String get step3 => '3. 八点式';

  @override
  String get step4 => '4. 眼镜蛇式（婴儿版）';

  @override
  String get step5 => '5. 眼镜蛇式（完整版）';

  @override
  String get step6 => '6. 回到下犬式';

  @override
  String get yogaHeadNeckShoulders => '头部、颈部与肩部伸展';

  @override
  String get yogaStraightArms => '直臂旋转';

  @override
  String get yogaBentArms => '屈臂旋转';

  @override
  String get yogaShouldersLateral => '肩膀侧向伸展';

  @override
  String get yogaShouldersTorsoTwist => '肩膀与躯干转体';

  @override
  String get yogaLegRaiseBent => '抬腿（屈膝）';

  @override
  String get yogaLegRaiseStraight => '抬腿（直膝）';

  @override
  String get yogaGoddessTwist => '女神式 — 躯干转体';

  @override
  String get yogaGoddessStrength => '女神式 — 腿部强化';

  @override
  String get yogaBackChestStretch => '背部与胸部伸展';

  @override
  String get yogaStandingCrunch => '站姿卷腹';

  @override
  String get yogaWarrior3Supported => '战士三式（有支撑）';

  @override
  String get yogaWarrior1Supported => '战士一式（有支撑）';

  @override
  String get yogaWarrior2Supported => '战士二式（有支撑）';

  @override
  String get yogaTriangleSupported => '三角式（有支撑）';

  @override
  String get yogaReverseWarrior2 => '反向战士二式';

  @override
  String get yogaSideAngleSupported => '侧角式（有支撑）';

  @override
  String get yogaGentleBreathing => '温和呼吸';

  @override
  String get yogaDownwardDog => '下犬式';

  @override
  String get yogaPlank => '板式 / 平板支撑';

  @override
  String get yogaEightPoint => '八点式';

  @override
  String get yogaBabyCobra => '小眼镜蛇式';

  @override
  String get yogaFullCobra => '眼镜蛇式';

  @override
  String get yogaSunSalutation => '拜日式流动';

  @override
  String get yogaSessionGentleChair => '温和椅子瑜伽';

  @override
  String get yogaSessionMorningMobility => '晨间灵活练习';

  @override
  String get yogaSessionWarriorSeries => '战士系列';

  @override
  String get yogaSessionHathaFundamentals => '哈达瑜伽基础';

  @override
  String get yogaSessionCoreStrength => '核心力量强化';

  @override
  String get yogaSessionBackbendFlow => '后弯流动';

  @override
  String get yogaSessionSunSalutation => '拜日式流动';

  @override
  String get yogaSessionExtendedFlow => '进阶流动练习';

  @override
  String get yogaDescHeadNeck => '温和的坐姿伸展，释放颈部和肩膀的紧张感。';

  @override
  String get yogaDescGentleChair =>
      '确保椅子稳定（可靠墙放置）。初级椅子瑜伽适合大多数人。建议空腹练习，或在餐后至少 2 小时进行。';

  @override
  String get yogaDescMorningMobility => '轻松的晨间练习，专注于关节灵活性、呼吸和有支撑的力量训练。';

  @override
  String get yogaDescWarriorSeries => '建立自信的序列，探索战士一式、二式及相关过渡动作。';

  @override
  String get yogaDescHathaFundamentals =>
      '经典的垫上哈达序列，专注于对齐、呼吸和全身参与。适合准备超越椅子支撑的练习者。';

  @override
  String get yogaDescCoreStrength => '短小精悍的课程，专注于板式、八点式和受控过渡。增强核心力量和肩膀稳定性。';

  @override
  String get yogaDescBackbendFlow => '强化脊椎的序列，从八点式过渡到小眼镜蛇式和眼镜蛇式。建立后弯的信心。';

  @override
  String get yogaDescSunSalutationSession =>
      '充满活力的垫上流动，旨在同步呼吸与动作。通过重复拜日式循环建立耐力和全身力量。';

  @override
  String get yogaDescExtendedFlow => '更深、更长的拜日式练习——适合希望在呼吸引导下挑战连续动作的经验丰富者。';

  @override
  String get yogaDescStraightArms => '手臂旋转以热身肩膀和上背部。';

  @override
  String get yogaDescBentArms => '屈肘的肩部灵活性练习。';

  @override
  String get yogaDescShouldersLateral => '改善灵活性的身体侧面伸展。';

  @override
  String get yogaDescShouldersTorsoTwist => '温和的排毒扭转动作。';

  @override
  String get yogaDescLegRaiseBent => '加强腿部力量并激活核心。';

  @override
  String get yogaDescLegRaiseStraight => '直腿抬高以进行进阶力量训练。';

  @override
  String get yogaDescGoddessTwist => '开胯坐姿以增进灵活性。';

  @override
  String get yogaDescGoddessStrength => '坐姿女神式的强化变体。';

  @override
  String get yogaDescBackChestStretch => 'L 型伸展以改善上半身灵活性。';

  @override
  String get yogaDescStandingCrunch => '动态核心强化动作。';

  @override
  String get yogaDescWarrior3Supported => '利用椅子支撑进行平衡与力量训练。';

  @override
  String get yogaDescWarrior1Supported => '适合初学者的战士站姿。';

  @override
  String get yogaDescWarrior2Supported => '面向侧边的战士式，用于打开髋关节。';

  @override
  String get yogaDescTriangleSupported => '深层侧身延伸。';

  @override
  String get yogaDescReverseWarrior2 => '后弯的战士式伸展。';

  @override
  String get yogaDescSideAngleSupported => '强化腿部并打开肋骨。';

  @override
  String get yogaDescGentleBreathing => '全身放紧与平静呼吸。';

  @override
  String get yogaDescDownwardDog => '基础的倒 V 姿势，伸展全身。';

  @override
  String get yogaDescPlank => '全身力量构建，参与核心、手臂和腿部。';

  @override
  String get yogaDescEightPoint => '强化力量的姿势，放下胸部、下巴、膝盖和脚趾。';

  @override
  String get yogaDescBabyCobra => '温和的后弯，强化上背部和脊柱。';

  @override
  String get yogaDescFullCobra => '更强的开胸后弯，全身参与。';

  @override
  String get yogaDescSunSalutation => '连接呼吸与动作的动态序列。建立力量、热量、协调性和耐力。';

  @override
  String get yogaInstHeadNeck =>
      '上下倾斜头部，各保持 5-10 次呼吸。转动头部左右各 3 圈。将耳朵靠向肩膀，可用手轻轻辅助。';

  @override
  String get yogaInstStraightArms => '握拳，直臂向前旋转 10 次，向后旋转 10 次。';

  @override
  String get yogaInstBentArms => '双肘在前方接触，向上绕过头后再向下。每个方向 10 圈。';

  @override
  String get yogaInstShouldersLateral => '右手垂向椅子，左臂向上举过头顶。保持 5-10 次呼吸，然后换边。';

  @override
  String get yogaInstShouldersTorsoTwist => '举起手臂，向右转动躯干，扶住椅子支撑。每侧保持 5-10 次呼吸。';

  @override
  String get yogaInstLegRaiseBent => '保持背部挺直，抬起弯曲的腿。保持后受控放下。换腿。';

  @override
  String get yogaInstLegRaiseStraight => '抬起伸直的腿，尽可能长时间保持。放松并换腿。';

  @override
  String get yogaInstGoddessTwist => '双膝张开，向侧面伸展躯干。保持 5-10 次呼吸，换边。';

  @override
  String get yogaInstGoddessStrength => '在女神式站姿中将大腿抬离椅子。保持 5-10 次呼吸。重复。';

  @override
  String get yogaInstBackChestStretch => '扶住椅子，铰链式下折呈 L 型，保持背部平坦。保持 5-10 次呼吸。';

  @override
  String get yogaInstStandingCrunch => '从 L 型开始，吸气时腿向后伸展，呼气时膝盖向前收缩。重复。';

  @override
  String get yogaInstWarrior3 => '手离开椅子，保持平衡。换腿并重复。';

  @override
  String get yogaInstWarrior1 => '向后迈步，弯曲前膝，举起双臂。保持 5-10 次呼吸。';

  @override
  String get yogaInstWarrior2 => '脚趾转向外侧，伸展手臂，看向前方。保持。';

  @override
  String get yogaInstTriangle => '伸直前腿，手向下触碰脚踝或瑜伽砖，另一手向上伸展。';

  @override
  String get yogaInstReverseWarrior => '向后倾斜时，上方手臂划过头顶。保持。';

  @override
  String get yogaInstSideAngle => '手降至脚内侧，上方手臂沿对角线向头顶上方延伸。';

  @override
  String get yogaInstGentleBreathing => '放松肩膀，双手放在大腿上，用鼻子缓慢呼吸。';

  @override
  String get yogaInstDownwardDog => '双手与肩同宽，双脚与髋同宽。抬高臀部，胸部向大腿方向下压。保持 5-10 次呼吸。';

  @override
  String get yogaInstPlank => '肩膀位于手腕正上方，收紧核心，身体从头到脚跟成一直线。保持 5-10 次呼吸。';

  @override
  String get yogaInstEightPoint => '从四足跪姿开始，放低胸部和下巴至垫上，臀部保持抬高。保持 5-10 次呼吸。';

  @override
  String get yogaInstBabyCobra => '俯卧，轻轻推起胸部，手肘夹紧身体，肩膀远离耳朵。保持 5-10 次呼吸。';

  @override
  String get yogaInstFullCobra => '伸直手肘，进一步抬高胸部，不要耸肩。保持 5-10 次呼吸。';

  @override
  String get yogaInstGentleBreathingIntermediate =>
      '双手放在腹部或大腿上，放松肩膀，用鼻子缓慢自然地呼吸。';

  @override
  String get yogaInstSunSalutation =>
      '此流动序列连续重复——一呼一吸配合一个动作。\n 1. 吸气 — 下犬式\n 抬高臀部，拉长脊柱。\n 2. 呼气 — 板式\n 向前移动进入强壮的板式位置。\n 3. 吸气 — 膝胸叩首（八点式）\n 受控下降，臀部抬高。\n 4. 呼气 — 小眼镜蛇式\n 轻轻抬起胸部，手肘靠近身体。\n 5. 吸气 — 眼镜蛇式\n 稍稍伸直手臂，打开胸腔。\n 6. 呼气 — 回到下犬式\n 向后压回倒 V 字型。\n 重复 5-10 轮或根据您的能力进行。';

  @override
  String get yogaGentleBreathingAdvanced => '通过鼻子柔和呼吸，拉长呼气。让全身沉静并放松。';

  @override
  String get yogaModMoveSlowly => '动作缓慢';

  @override
  String get yogaModStopDizzy => '若感到晕眩请停止';

  @override
  String get yogaModChairSupport => '使用椅背支撑';

  @override
  String get yogaModElbowsStraight => '保持手肘伸直';

  @override
  String get yogaModControlledMove => '动作平稳且受控';

  @override
  String get yogaModFingersShoulders => '手指保持在肩膀上';

  @override
  String get yogaModSlowRolls => '缓慢且受控地转动';

  @override
  String get yogaModButtocksDown => '保持臀部坐稳';

  @override
  String get yogaModFaceForward => '面向前方';

  @override
  String get yogaModHipsStable => '保持髋部稳定';

  @override
  String get yogaModShouldersLevel => '保持双肩齐平';

  @override
  String get yogaModBackStraight => '保持背部挺直';

  @override
  String get yogaModBeginBent => '从屈膝版本开始';

  @override
  String get yogaModUseChairForSupport => '使用椅子支撑';

  @override
  String get yogaModKneesToes => '膝盖与脚趾对齐';

  @override
  String get yogaModHipsGrounded => '保持臀部贴地/贴椅';

  @override
  String get yogaModTorsoUpright => '保持躯干挺直';

  @override
  String get yogaModChairBalance => '使用椅子保持平衡';

  @override
  String get yogaModArmsLegsStraight => '保持手臂和腿部伸直';

  @override
  String get yogaModEngageCore => '收紧核心';

  @override
  String get yogaModAvoidPregnancy => '怀孕期间请避免';

  @override
  String get yogaModOneHandChair => '保持一只手扶着椅子';

  @override
  String get yogaModStraightLine => '保持身体呈一直线';

  @override
  String get yogaModShortenStance => '缩短站距';

  @override
  String get yogaModSquareHips => '摆正髋部';

  @override
  String get yogaModLevelShoulders => '水平肩膀';

  @override
  String get yogaModUseBlock => '使用瑜伽砖';

  @override
  String get yogaModHipsForward => '保持髋部朝前';

  @override
  String get yogaModFrontKneeBent => '保持前膝弯曲';

  @override
  String get yogaModGazeDirection => '选择凝视方向';

  @override
  String get yogaModTuckTailbone => '轻微收尾骨';

  @override
  String get yogaModSitOrLieDown => '坐下或躺下';

  @override
  String get yogaModCloseEyesIfComfortable => '若感觉舒适可闭上眼睛';

  @override
  String get yogaModBendKnees => '若腿筋紧绷可弯曲膝盖';

  @override
  String get yogaModHeelsLifted => '练习时脚跟抬起';

  @override
  String get yogaModLowerKnees => '放下膝盖以进行温和版本';

  @override
  String get yogaModFeetTogether => '双脚并拢以增加挑战';

  @override
  String get yogaModSlowControl => '缓慢受控下降以保护肩膀';

  @override
  String get yogaModLiftPalms => '抬起手掌以增加挑战';

  @override
  String get yogaModPressFeet => '双脚向下踩实以增加稳定性';

  @override
  String get yogaModNoLockElbows => '不要锁死手肘';

  @override
  String get yogaModTuckStomach => '轻微收腹以支持脊柱';

  @override
  String get yogaModRestChildPose => '如有需要，在两轮之间于婴儿式休息';

  @override
  String get yogaModSlowTransitions => '如果呼吸变得吃力，请放慢过渡动作';

  @override
  String get yogaModBendDownwardDog => '在下犬式中弯曲膝盖以增加舒适感';

  @override
  String get yogaModSitOrLie => '坐直或平躺';

  @override
  String get yogaModCushionUnderKnees => '在膝盖下放置垫子';

  @override
  String get sessionLevelLabel => '难度等级';

  @override
  String get sessionTotalTimeLabel => '总时长';

  @override
  String get sessionTotalPosesLabel => '总姿势数';

  @override
  String get aboutThisSession => '课程简介';

  @override
  String get posesPreview => '姿势预览';

  @override
  String posesCompletedCount(int completed, int total) {
    return '已完成 $completed / $total 个姿势';
  }

  @override
  String get practiceAgain => '再次练习';

  @override
  String get posesLabel => '个姿势';

  @override
  String get duration => '时长';

  @override
  String get poses => '姿势';

  @override
  String get intensity => '强度';

  @override
  String get low => '低';

  @override
  String get aboutSession => '关于课程';

  @override
  String get sessionOverview => '课程概览';

  @override
  String get joinClass => '参加课程';

  @override
  String dayNumber(int number) {
    return '第 $number 天';
  }

  @override
  String minsLabel(int count) {
    return '$count 分钟';
  }

  @override
  String get completeCurrentPoseFirst => '请先完成当前的动作！';

  @override
  String get poseComplete => '动作完成！';

  @override
  String get greatWorkChoice => '做得好！接下来您想做什么？';

  @override
  String get retryPose => '再做一次';

  @override
  String get nextPose => '下一个姿势';

  @override
  String get finishSession => '结束课程';

  @override
  String get sessionComplete => '课程完成！';

  @override
  String completedPoses(int count) {
    return '已完成 $count 个动作';
  }

  @override
  String totalMinutesSpent(int value, String unit) {
    return '您已练习了 $value $unit';
  }

  @override
  String get totaltime => '总练习时长：';

  @override
  String get howToPose => '动作指南';

  @override
  String get sessionPlaylist => '课程列表';

  @override
  String get playing => '播放中';

  @override
  String get pause => '暂停';

  @override
  String get resume => '继续';

  @override
  String get waitingForPin => '等待输入密码...';

  @override
  String get exitSessionTitle => '退出练习？';

  @override
  String posesCompletedInfo(int completed, int total) {
    return '已完成 $completed / $total 个动作';
  }

  @override
  String get progressSaved => '进度已保存 ✓';

  @override
  String get continueLater => '您可以随时回来继续练习！';

  @override
  String get noPosesCompleted => '尚未完成任何动作';

  @override
  String get completeOneToSave => '请至少完成一个动作以保存您的进度。';

  @override
  String get stayButton => '继续练习';

  @override
  String get playbackNormal => '正常';

  @override
  String poseProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get videoTutorial => '视频教程';

  @override
  String get safetyTips => '安全提示';

  @override
  String get tip1 => '保持膝盖微屈以避免关节受压';

  @override
  String get tip2 => '在整个姿势中收紧核心肌肉';

  @override
  String get tip3 => '不要强迫脚后跟触地';

  @override
  String get tip4 => '深呼吸，避免屏息';

  @override
  String get tip5 => '如果感到疼痛，请缓慢退出姿势';

  @override
  String get markAsCompleted => '标记为已完成';

  @override
  String get completed => '已完成';

  @override
  String get poseMarkedSuccess => '姿势已标记为完成！';

  @override
  String get completeSession => '完成课程';

  @override
  String get congratulations => '🎉 恭喜！';

  @override
  String get sessionCompleteDesc => '您已完成本课程中的所有姿势！';

  @override
  String get done => '完成';

  @override
  String get poseDetailTitle => '姿势详情';

  @override
  String get howToDoTitle => '动作要领';

  @override
  String get learningNotice => '此处仅供学习参考。如需记录进度，请从课程界面点击“加入课程”。';

  @override
  String poseCurrentCount(int current, int total) {
    return '第 $current / $total 个';
  }

  @override
  String durationFormat(int minutes, String seconds) {
    return '$minutes:$seconds 分钟';
  }

  @override
  String get calendar => '练习日历';

  @override
  String get activitySummary => '活动摘要';

  @override
  String get totalMinutes => '总分钟数';

  @override
  String get thisWeek => '本周进度';

  @override
  String get dailyMinutes => '每日时长';

  @override
  String get week => '周';

  @override
  String get nothingTracked => '暂无记录';

  @override
  String get min => '分钟';

  @override
  String ofGoal(int goal) {
    return '目标 $goal 分钟';
  }

  @override
  String get weeklyBadges => '每周勋章';

  @override
  String get wellnessCheckIn => '健康打卡';

  @override
  String get checkedInThisWeek => '本周已打卡 ✓';

  @override
  String get howAreYouFeeling => '您今天感觉如何？';

  @override
  String get checkInButton => '开始打卡';

  @override
  String get historyButton => '查看历史';

  @override
  String get practice => '练习日';

  @override
  String get restDay => '休息日';

  @override
  String get reflectionHistory => '感悟历史';

  @override
  String get noReflections => '暂无感悟记录';

  @override
  String get bodyComfort => '身体舒适度';

  @override
  String get flexibility => '灵活性';

  @override
  String get balance => '平衡力';

  @override
  String get energy => '精力水平';

  @override
  String get mood => '情绪状态';

  @override
  String get confidence => '日常自信心';

  @override
  String get mindBody => '身心连接';

  @override
  String get wellbeing => '整体健康';

  @override
  String get notes => '备注：';

  @override
  String get wellnessDialogTitle => '健康打卡';

  @override
  String get wellnessDialogSubtitle => '请评估您过去一周的感受';

  @override
  String get qBodyComfort => '练习时身体感到舒适吗？';

  @override
  String get qFlexibility => '您觉得最近身体变灵活了吗？';

  @override
  String get qBalance => '平衡动作练习得稳吗？';

  @override
  String get qEnergy => '您的精力水平如何？';

  @override
  String get qMood => '最近心情怎么样？';

  @override
  String get qConfidence => '日常生活中感到自信吗？';

  @override
  String get qBodyConnection => '练习时能感受到身心连接吗？';

  @override
  String get qOverall => '总体而言，您对目前的健康状况满意吗？';

  @override
  String get notesOptional => '备注（选填）';

  @override
  String get cancel => '取消';

  @override
  String get submit => '提交';

  @override
  String get rateAllError => '请评价所有项目后再提交';

  @override
  String get checkInSaved => '健康打卡已保存！';

  @override
  String get platinum => '铂金';

  @override
  String get gold => '黄金';

  @override
  String get silver => '白银';

  @override
  String get bronze => '青铜';

  @override
  String get none => '无';

  @override
  String get section1Title => '第一部分 – 身体舒适度与灵活性';

  @override
  String get section2Title => '第二部分 – 精力与情绪';

  @override
  String get section3Title => '第三部分 – 觉知与自信';

  @override
  String get section4Title => '⭐ 整体健康';

  @override
  String get qBodyComfortFull => '1️⃣ 运动时身体感觉有多舒适？';

  @override
  String get optComfort1 => '不舒适';

  @override
  String get optComfort2 => '略微舒适';

  @override
  String get optComfort3 => '中度舒适';

  @override
  String get optComfort4 => '非常舒适';

  @override
  String get optComfort5 => '极其舒适';

  @override
  String get qFlexibilityFull => '2️⃣ 您如何描述最近的灵活性？';

  @override
  String get optFlexibility1 => '僵硬得多';

  @override
  String get optFlexibility2 => '有点僵硬';

  @override
  String get optFlexibility3 => '差不多';

  @override
  String get optFlexibility4 => '更有弹性了';

  @override
  String get optFlexibility5 => '灵活得多';

  @override
  String get qBalanceFull => '3️⃣ 站立或平衡时感觉稳吗？';

  @override
  String get optBalance1 => '一点也不稳';

  @override
  String get optBalance2 => '略微稳当';

  @override
  String get optBalance3 => '中度稳当';

  @override
  String get optBalance4 => '非常稳当';

  @override
  String get optBalance5 => '极其稳当';

  @override
  String get qEnergyFull => '4️⃣ 您的整体精力水平如何？';

  @override
  String get optEnergy1 => '非常低';

  @override
  String get optEnergy2 => '低';

  @override
  String get optEnergy3 => '一般';

  @override
  String get optEnergy4 => '良好';

  @override
  String get optEnergy5 => '非常好';

  @override
  String get qMoodFull => '5️⃣ 最近的心情怎么样？';

  @override
  String get optMood1 => '经常感到压力或沮丧';

  @override
  String get optMood2 => '有时感到压力';

  @override
  String get optMood3 => '大多还好';

  @override
  String get optMood4 => '大多积极';

  @override
  String get optMood5 => '非常积极和平静';

  @override
  String get qConfidenceFull => '6️⃣ 进行日常活动时感觉有多自信？';

  @override
  String get optConfidence1 => '不自信';

  @override
  String get optConfidence2 => '略微自信';

  @override
  String get optConfidence3 => '有些自信';

  @override
  String get optConfidence4 => '自信';

  @override
  String get optConfidence5 => '非常自信';

  @override
  String get qBodyConnectionFull => '7️⃣ 练习瑜伽时与身体的连接感如何？';

  @override
  String get optConnection1 => '没有连接感';

  @override
  String get optConnection2 => '有一点连接感';

  @override
  String get optConnection3 => '中度连接感';

  @override
  String get optConnection4 => '非常有连接感';

  @override
  String get optConnection5 => '深度连接';

  @override
  String get qOverallFull => '8️⃣ 总体而言，您如何评价本月的健康状况？';

  @override
  String get optOverall1 => '较差';

  @override
  String get optOverall2 => '一般';

  @override
  String get optOverall3 => '好';

  @override
  String get optOverall4 => '非常好';

  @override
  String get optOverall5 => '极好';

  @override
  String get monthlyReflections => '💭 每月感悟（选填）';

  @override
  String get shareImprovements => '分享您注意到的具体进步：';

  @override
  String get labelBalance => '🧘 平衡力提升';

  @override
  String get hintBalance => '例如：我可以单脚站立更久了...';

  @override
  String get labelPosture => '🪑 体态改善';

  @override
  String get hintPosture => '例如：我的背感觉更直了...';

  @override
  String get labelConsistency => '📅 坚持与习惯';

  @override
  String get hintConsistency => '例如：我现在每天早上都练习...';

  @override
  String get labelOther => '💬 其他想法';

  @override
  String get hintOther => '任何其他进步或笔记...';

  @override
  String get skipForNow => '暂时跳过';

  @override
  String get submitCheckIn => '提交打卡';

  @override
  String get validationErrorCheckIn => '提交前请回答所有必填问题';

  @override
  String get nowPlaying => '正在播放';

  @override
  String get moreDetails => '更多详情';

  @override
  String get aboutThisSound => '关于此声音';

  @override
  String get category => '类别';

  @override
  String get type => '类型';

  @override
  String get meditationType => '冥想与放松';

  @override
  String get benefits => '益处';

  @override
  String get soundBenefit1 => '• 减轻压力和焦虑';

  @override
  String get soundBenefit2 => '• 提高注意力和专注力';

  @override
  String get soundBenefit3 => '• 促进更好的睡眠';

  @override
  String get soundBenefit4 => '• 提升整体幸福感';

  @override
  String get meditationHeader => '冥想与白噪音';

  @override
  String get quickStart => '快速开始';

  @override
  String get guidedMeditationSection => '引导式冥想';

  @override
  String get ambientSoundsSection => '大自然的声音';

  @override
  String get ambientSoundsSubtitle => '纯净的大自然声音助您放松';

  @override
  String get morningClarityTitle => '晨间清爽';

  @override
  String get morningClarityDesc => '开启充满宁静与力量的一天';

  @override
  String get deepBreathingTitle => '深呼吸练习';

  @override
  String get deepBreathingDesc => '通过专注呼吸缓解压力';

  @override
  String get eveningWindDownTitle => '晚间放松';

  @override
  String get eveningWindDownDesc => '卸下疲惫，准备进入梦乡';

  @override
  String get oceanWavesTitle => '海浪声';

  @override
  String get oceanWavesDesc => '海浪拍打沙滩的柔和声';

  @override
  String get rainSoundsTitle => '雨声';

  @override
  String get rainSoundsDesc => '淅沥的雨声与闷雷';

  @override
  String get forestBirdsTitle => '森林鸟鸣';

  @override
  String get forestBirdsDesc => '置身于大自然的鸟语花香';

  @override
  String get cracklingFireTitle => '木柴燃烧声';

  @override
  String get cracklingFireDesc => '壁炉火堆的温暖声';

  @override
  String get whiteNoiseTitle => '白噪音';

  @override
  String get whiteNoiseDesc => '纯净白噪音，助力专注';

  @override
  String get flowingWaterTitle => '流水潺潺';

  @override
  String get flowingWaterDesc => '溪水流过的清脆声';

  @override
  String get windChimesTitle => '清脆风铃';

  @override
  String get windChimesDesc => '宁静祥和的风铃声';

  @override
  String get nightCricketsTitle => '夏夜虫鸣';

  @override
  String get nightCricketsDesc => '宁静夜晚的蛐蛐叫声';

  @override
  String get meditationHeaderTitle => '选择您的冥想课程';

  @override
  String get meditationHeaderSubtitle => '停下来，深呼吸';

  @override
  String get meditationQuickStart => '快速开始 • 5-10 分钟';

  @override
  String get meditationAllSection => '所有冥想';

  @override
  String get meditationCategoryLabel => '冥想';

  @override
  String meditationDurationMin(int count) {
    return '$count 分钟';
  }

  @override
  String get meditationSessionMorningTitle => '晨间清透';

  @override
  String get meditationSessionMorningDesc => '以平和的心境开启新的一天';

  @override
  String get meditationSessionBreathingTitle => '深呼吸练习';

  @override
  String get meditationSessionBreathingDesc => '通过专注呼吸缓解压力';

  @override
  String get meditationSessionEveningTitle => '睡前放松';

  @override
  String get meditationSessionEveningDesc => '放下疲惫，为休息做好准备';

  @override
  String get soundCategory => '环境音';

  @override
  String get meditationPreparing => '正在为您准备课程...';

  @override
  String get meditationCancel => '取消课程';

  @override
  String get meditationEndSession => '结束课程';

  @override
  String get meditationComplete => '课程已完成';

  @override
  String get meditationInhale => '吸气...';

  @override
  String get meditationExhale => '呼气...';

  @override
  String get meditationHold => '屏息...';

  @override
  String get meditationEndTitle => '结束课程？';

  @override
  String get meditationEndMessage => '您确定要结束当前的冥想课程吗？';

  @override
  String get meditationConfirmEnd => '结束';

  @override
  String get profileTitle => '个人中心';

  @override
  String get edit => '编辑';

  @override
  String get minutesLabel => '分钟';

  @override
  String get daily => '每日 🔥';

  @override
  String get streakSummary => '连续天数总结';

  @override
  String get weeklyActive => '每周活跃周数';

  @override
  String get preferences => '偏好设置';

  @override
  String get enabled => '已启用';

  @override
  String get disabled => '已禁用';

  @override
  String get signout => '登出';

  @override
  String get aboutus => '关于我们';

  @override
  String get editProfile => '编辑个人资料';

  @override
  String get save => '保存';

  @override
  String get uploadPhoto => '上传照片';

  @override
  String get removePhoto => '移除照片';

  @override
  String get photoUpdated => '头像已更新';

  @override
  String get photoRemoved => '头像已移除';

  @override
  String get photoFail => '上传失败';

  @override
  String get basicInfo => '基本信息';

  @override
  String get fullName => '全名';

  @override
  String get age => '年龄';

  @override
  String get experienceLevel => '经验等级';

  @override
  String get sessionLength => '课程时长';

  @override
  String get language => '语言';

  @override
  String get notifications => '通知';

  @override
  String get pushNotifications => '推送通知';

  @override
  String get pushEnabledMsg => '推送通知已启用！🔔';

  @override
  String get dailyReminder => '每日练习提醒';

  @override
  String get dailyReminderEnabled => '每日提醒已启用！';

  @override
  String get dailyEnabledMsg => '我们每天都会提醒您练习。🌞';

  @override
  String get reminderTime => '提醒时间';

  @override
  String get dailyReminderNotification => '每日练习提醒';

  @override
  String get dailyReminderBody => '该做每日瑜伽练习了！🏃‍♀️';

  @override
  String get sound => '声音';

  @override
  String get soundEffects => '音效';

  @override
  String get appVolume => '应用音量';

  @override
  String get systemVolume => '系统音量';

  @override
  String get appVolumeDesc => '调整应用内声音的音量';

  @override
  String get systemVolumeDesc => '调整您的设备系统音量';

  @override
  String get validationError => '姓名和年龄为必填项';

  @override
  String get beginner => '初学者';

  @override
  String get intermediate => '中级';

  @override
  String get advanced => '高级';

  @override
  String get min5 => '5 分钟';

  @override
  String get min10 => '10 分钟';

  @override
  String get min15 => '15 分钟';

  @override
  String get min20 => '20 分钟';

  @override
  String get min30 => '30 分钟';

  @override
  String get english => '英文';

  @override
  String get mandarinSimplified => '简体中文';

  @override
  String get mandarinTraditional => '繁体中文';

  @override
  String completedPosesCount(int count) {
    return '您完成了 $count 个姿势！';
  }

  @override
  String get minutes => '分钟';

  @override
  String get next => '下一步';

  @override
  String get aboutThisPose => '关于此姿势';

  @override
  String get exitSession => '退出课程？';

  @override
  String get exitSessionMessage => '如果现在退出，您的进度将不会被保存。确定要退出吗？';

  @override
  String get exit => '退出';

  @override
  String get aboutUsTitle => '关于我们';

  @override
  String get appName => 'Zencore';

  @override
  String get appVersion => '版本 1.0.0';

  @override
  String get ourMission => '我们的使命';

  @override
  String get missionStatement => '通过温和的椅子瑜伽、舒缓的冥想和正念练习，让每个人都能享受健康生活。';

  @override
  String get projectTeam => '项目团队';

  @override
  String get projectSupervisor => '项目主管';

  @override
  String get developmentTeam => '开发团队';

  @override
  String get yogaInstructor => '瑜伽导师';

  @override
  String get keyFeatures => '核心功能';

  @override
  String get featureChairYoga => '椅子瑜伽课程';

  @override
  String get featureMeditation => '专业冥想指导';

  @override
  String get featureProgress => '进度跟踪';

  @override
  String get featureSounds => '助眠舒缓音效';

  @override
  String get licensesTitle => '开源许可';

  @override
  String get licenseDescription => 'HealYoga 是使用開源軟體構建的。您可以在下方查看完整的許可列表。';

  @override
  String get viewLicensesButton => '查看所有许可';

  @override
  String get copyright => '© 2026 ZENCORE';

  @override
  String get allRightsReserved => '保留所有权利';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get registerTitle => '開啟您的健康之旅';

  @override
  String get registerSubtitle => '建立帳號以開始練習';

  @override
  String get stepPersonal => '個人資訊';

  @override
  String get stepPreferences => '偏好設定';

  @override
  String get stepAccount => '帳號設定';

  @override
  String get getToknowYou => '👋 讓我們了解您';

  @override
  String get tellUsAbout => '請向我們介紹一下您自己';

  @override
  String get yourPreferences => '⚙️ 您的偏好';

  @override
  String get customizeYoga => '客製化您的瑜伽體驗';

  @override
  String get secureAccount => '🔐 保護您的帳號';

  @override
  String get createCredentials => '建立您的登入資訊';

  @override
  String get passwordReqTitle => '密碼要求：';

  @override
  String get reqLength => '至少 8 個字元';

  @override
  String get reqUpper => '1 個大寫字母 (A-Z)';

  @override
  String get reqLower => '1 個小写字母 (a-z)';

  @override
  String get reqNumber => '1 個數字 (0-9)';

  @override
  String get reqSpecial => '1 個特殊字元 (!@#\$%...)';

  @override
  String get alreadyHaveAccount => '已經有帳號？登入';

  @override
  String get back => '返回';

  @override
  String get createAccount => '建立帳號';

  @override
  String get nameHint => '輸入您的姓名';

  @override
  String get ageHint => '輸入您的年齡';

  @override
  String get emailHint => 'your.email@example.com';

  @override
  String get passwordHint => '最少 8 位：包含大小寫字母、數字和特殊字元';

  @override
  String get errEmailEmpty => '請輸入您的電子郵件';

  @override
  String get errEmailInvalid => '請輸入有效的電子郵件地址';

  @override
  String get errPasswordEmpty => '請輸入密碼';

  @override
  String get errNameEmpty => '請輸入您的全名';

  @override
  String get errAgeEmpty => '請輸入有效年齡（僅限數字）';

  @override
  String get errAgeRange => '請輸入 1 到 120 之間的有效年齡';

  @override
  String get checkEmailMsg => '請檢查您的信箱以確認帳號';

  @override
  String welcomeName(String name) {
    return '歡迎，$name! 🌿';
  }

  @override
  String get completeProfileTitle => '完善您的個人資料 🌸';

  @override
  String get completeProfileSubtitle => '只需幾個快速細節即可個人化您的瑜伽之旅。';

  @override
  String get preferredLanguage => '首選語言';

  @override
  String get enterValidAge => '請輸入有效年齡';

  @override
  String get profileCompleted => '資料已完善 🌿';

  @override
  String saveProfileFailed(String error) {
    return '儲存資料失敗：$error';
  }

  @override
  String get enableNotifications => '啟用通知';

  @override
  String get continueButton => '繼續';

  @override
  String get under18 => '18 歲以下';

  @override
  String ageRange(int start, int end) {
    return '$start-$end 歲';
  }

  @override
  String get welcomeBack => '歡迎回來 🧘‍♀️';

  @override
  String get loginSubtitle => '登入以繼續您的療癒之旅。';

  @override
  String get email => '電子郵件';

  @override
  String get password => '密碼';

  @override
  String get logIn => '登入';

  @override
  String get signInWithGoogle => '使用 Google 登入';

  @override
  String get dontHaveAccount => '還沒有帳號？註冊';

  @override
  String get fillRequiredFields => '請填寫所有必填欄位';

  @override
  String get loginSuccess => '歡迎回來 🌿';

  @override
  String loginFailed(String error) {
    return '登入失敗：$error';
  }

  @override
  String googleSignInFailed(String error) {
    return 'Google 登入失敗：$error';
  }

  @override
  String get forgotPassword => '忘記密碼？';

  @override
  String get resetPassword => '重設密碼';

  @override
  String get resetPasswordTitle => '重設您的密碼';

  @override
  String get resetPasswordSubtitle => '輸入您的電子郵件，我們將向您發送重設連結';

  @override
  String get sendResetLink => '發送重設連結';

  @override
  String get resetLinkSent => '密碼重設連結已發送！請檢查您的電子郵件 📧';

  @override
  String resetLinkFailed(String error) {
    return '發送重設連結失敗：$error';
  }

  @override
  String get backToLogin => '返回登入';

  @override
  String get invalidCredentials => '電子郵件或密碼無效。請重試。';

  @override
  String get emailNotVerified => '請在登入前驗證您的電子郵件。請檢查您的收件匣。';

  @override
  String get accountNotFound => '未找到該電子郵件的帳號。請先註冊。';

  @override
  String get tooManyAttempts => '登入嘗試次數過多。請稍後重試。';

  @override
  String get networkError => '網路錯誤。請檢查您的連線後重試。';

  @override
  String get unknownError => '發生意外錯誤。請重試。';

  @override
  String get emailAlreadyExists => '該電子郵件已註冊。請改用登入。';

  @override
  String get weakPassword => '密碼太弱。請遵循要求。';

  @override
  String get changeLanguage => '更改語言';

  @override
  String get onboardingHeading => '感受更強健的自己';

  @override
  String get onboardingDesc => '隨時隨地在家中或旅途中，\n向世界頂尖的瑜伽教練學習。';

  @override
  String get letsExplore => '讓我們開始探索';

  @override
  String get navHome => '首頁';

  @override
  String get navSessions => '課程';

  @override
  String get navProgress => '進度';

  @override
  String get navMeditation => '冥想';

  @override
  String get navProfile => '個人中心';

  @override
  String get appTagline => '尋找內心的平靜';

  @override
  String get goodMorning => '早安！';

  @override
  String get goodAfternoon => '午安！';

  @override
  String get goodEvening => '晚安！';

  @override
  String get friend => '朋友';

  @override
  String get findYourPeace => '尋找內心的平靜';

  @override
  String get calmingSounds => '為您的健康提供舒緩的聲音';

  @override
  String get listenNow => '立即收聽';

  @override
  String get yogaSubtitle => '非常適合剛開始瑜伽之旅的人';

  @override
  String get joinNow => '立即加入';

  @override
  String get wellnessOverview => '健康概覽';

  @override
  String get haveANiceDay => '祝你今天愉快！';

  @override
  String get selectDate => '選擇日期';

  @override
  String get todaysPractice => '今日練習';

  @override
  String get recommendedForYou => '為你推薦';

  @override
  String get seeAll => '查看全部';

  @override
  String get ambient => '環境音';

  @override
  String get streak => '連續天數';

  @override
  String get sessions => '練習次數';

  @override
  String get weekly => '本週';

  @override
  String get totalTime => '總時長';

  @override
  String daysCount(int count) {
    return '$count 天';
  }

  @override
  String minutesCount(int count) {
    return '$count 分鐘';
  }

  @override
  String get beginYour => '開啟您的';

  @override
  String get wellnessJourney => '健康之旅';

  @override
  String get beginnerSubtitle => '椅子瑜伽';

  @override
  String get beginnerDesc => '非常適合剛開始瑜伽之旅的人';

  @override
  String get intermediateSubtitle => '墊上哈他瑜伽';

  @override
  String get intermediateDesc => '透過挑戰性的序列增強力量';

  @override
  String get advancedSubtitle => '動態流向日式';

  @override
  String get advancedDesc => '透過流動的序列挑戰自我';

  @override
  String lockedLevelTitle(String levelName) {
    return '$levelName 已鎖定';
  }

  @override
  String completeSessionsToUnlock(int count) {
    return '再完成 $count 個課程以解鎖';
  }

  @override
  String get unlockIntermediateFirst => '請先解鎖中級';

  @override
  String sessionsProgress(int current, int required) {
    return '$current / $required 課程';
  }

  @override
  String sessionsCompletedCount(int count) {
    return '已完成 $count 個課程';
  }

  @override
  String get errorLoadingProgress => '載入進度出錯';

  @override
  String get retry => '重試';

  @override
  String get ok => '確定';

  @override
  String get enterPasscodeHint => '管理員密碼 🔐';

  @override
  String get moreInfo => '更多資訊';

  @override
  String get enterPinCode => '輸入密碼';

  @override
  String get pinInstructions => '請輸入4位密碼以觀看影片';

  @override
  String get incorrectPin => '密碼錯誤';

  @override
  String get backdoorAccess => '管理員存取';

  @override
  String get backdoorAdminMsg => '您擁有更改影片密碼的管理員權限。';

  @override
  String get backdoorPathInstructions => '請前往 個人資料 > 設置 以更改密碼。';

  @override
  String get beginnerTitle => '初級課程';

  @override
  String get warmup => '熱身';

  @override
  String get mainPractice => '主練習';

  @override
  String get cooldown => '放鬆/冷卻';

  @override
  String get viewDetails => '查看詳情';

  @override
  String poseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個姿勢',
      one: '1 個姿勢',
    );
    return '$_temp0';
  }

  @override
  String sessionsCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已完成 $count 個課程',
      one: '已完成 1 個課程',
    );
    return '$_temp0';
  }

  @override
  String get intermediateTitle => '中級課程';

  @override
  String get hathaPractice => '哈他練習';

  @override
  String get startSession => '開始課程';

  @override
  String get advancedTitle => '高級課程';

  @override
  String get dynamicFlowNotice => '動態流練習。隨呼吸而動。';

  @override
  String get advancedLabel => '高級';

  @override
  String get highIntensity => '高強度';

  @override
  String get sunSalutationTitle => '向日式流';

  @override
  String get repeatRounds => '重複 5-10 輪 • 一呼一吸，一個動作';

  @override
  String get beginFlow => '開始流動';

  @override
  String get step1 => '1. 下犬式';

  @override
  String get step2 => '2. 板式';

  @override
  String get step3 => '3. 八點式';

  @override
  String get step4 => '4. 眼鏡蛇式（嬰兒版）';

  @override
  String get step5 => '5. 眼鏡蛇式（完整版）';

  @override
  String get step6 => '6. 回到下犬式';

  @override
  String get yogaHeadNeckShoulders => '頭部、頸部與肩部伸展';

  @override
  String get yogaStraightArms => '直臂旋轉';

  @override
  String get yogaBentArms => '屈臂旋轉';

  @override
  String get yogaShouldersLateral => '肩膀側向伸展';

  @override
  String get yogaShouldersTorsoTwist => '肩膀與軀幹轉體';

  @override
  String get yogaLegRaiseBent => '抬腿（屈膝）';

  @override
  String get yogaLegRaiseStraight => '抬腿（直膝）';

  @override
  String get yogaGoddessTwist => '女神式 — 軀幹轉體';

  @override
  String get yogaGoddessStrength => '女神式 — 腿部強化';

  @override
  String get yogaBackChestStretch => '背部與胸部伸展';

  @override
  String get yogaStandingCrunch => '站姿捲腹';

  @override
  String get yogaWarrior3Supported => '戰士三式（有支撐）';

  @override
  String get yogaWarrior1Supported => '戰士一式（有支撐）';

  @override
  String get yogaWarrior2Supported => '戰士二式（有支撐）';

  @override
  String get yogaTriangleSupported => '三角式（有支撐）';

  @override
  String get yogaReverseWarrior2 => '反向戰士二式';

  @override
  String get yogaSideAngleSupported => '側角式（有支撐）';

  @override
  String get yogaGentleBreathing => '溫和呼吸';

  @override
  String get yogaDownwardDog => '下犬式';

  @override
  String get yogaPlank => '板式 / 平板支撐';

  @override
  String get yogaEightPoint => '八點式';

  @override
  String get yogaBabyCobra => '小眼鏡蛇式';

  @override
  String get yogaFullCobra => '眼鏡蛇式';

  @override
  String get yogaSunSalutation => '向陽起航 / 拜日式流動';

  @override
  String get yogaSessionGentleChair => '溫和椅子瑜珈';

  @override
  String get yogaSessionMorningMobility => '晨間靈活練習';

  @override
  String get yogaSessionWarriorSeries => '戰士系列';

  @override
  String get yogaSessionHathaFundamentals => '哈達瑜珈基礎';

  @override
  String get yogaSessionCoreStrength => '核心力量強化';

  @override
  String get yogaSessionBackbendFlow => '後彎流動';

  @override
  String get yogaSessionSunSalutation => '拜日式流動';

  @override
  String get yogaSessionExtendedFlow => '進階流動練習';

  @override
  String get yogaDescHeadNeck => '溫和的坐姿伸展，釋放頸部和肩膀的緊張感。';

  @override
  String get yogaDescGentleChair =>
      '確保椅子穩定（可靠牆放置）。初級椅子瑜珈適合大多數人。建議空腹練習，或在餐後至少 2 小時進行。';

  @override
  String get yogaDescMorningMobility => '輕鬆的晨間練習，專注於關節靈活性、呼吸和有支撐的力量訓練。';

  @override
  String get yogaDescWarriorSeries => '建立自信的序列，探索戰士一式、二式及相關過渡動作。';

  @override
  String get yogaDescHathaFundamentals =>
      '經典的墊上哈達序列，專注於對齊、呼吸和全身參與。適合準備超越椅子支撐的練習者。';

  @override
  String get yogaDescCoreStrength => '短小精悍的課程，專注於板式、八點式和受控過渡。增強核心力量和肩膀穩定性。';

  @override
  String get yogaDescBackbendFlow => '強化脊椎的序列，從八點式過渡到小眼鏡蛇式和眼鏡蛇式。建立後彎的信心。';

  @override
  String get yogaDescSunSalutationSession =>
      '充滿活力的墊上流動，旨在同步呼吸與動作。通過重複拜日式循環建立耐力和全身力量。';

  @override
  String get yogaDescExtendedFlow => '更深、更長的拜日式練習——適合希望在呼吸引導下挑戰連續動作的經驗豐富者。';

  @override
  String get yogaDescStraightArms => '手臂旋轉以熱身肩膀和上背部。';

  @override
  String get yogaDescBentArms => '屈肘的肩部靈活性練習。';

  @override
  String get yogaDescShouldersLateral => '改善靈活性的身體側面伸展。';

  @override
  String get yogaDescShouldersTorsoTwist => '溫和的排毒扭轉動作。';

  @override
  String get yogaDescLegRaiseBent => '加強腿部力量並激活核心。';

  @override
  String get yogaDescLegRaiseStraight => '直腿抬高以進行進階力量訓練。';

  @override
  String get yogaDescGoddessTwist => '開胯坐姿以增進靈活性。';

  @override
  String get yogaDescGoddessStrength => '坐姿女神式的強化變體。';

  @override
  String get yogaDescBackChestStretch => 'L 型伸展以改善上半身靈活性。';

  @override
  String get yogaDescStandingCrunch => '動態核心強化動作。';

  @override
  String get yogaDescWarrior3Supported => '利用椅子支撐進行平衡與力量訓練。';

  @override
  String get yogaDescWarrior1Supported => '適合初學者的戰士站姿。';

  @override
  String get yogaDescWarrior2Supported => '面向側邊的戰士式，用於打開髖關節。';

  @override
  String get yogaDescTriangleSupported => '深層側身延伸。';

  @override
  String get yogaDescReverseWarrior2 => '後彎的戰士式伸展。';

  @override
  String get yogaDescSideAngleSupported => '強化腿部並打開肋骨。';

  @override
  String get yogaDescGentleBreathing => '全身放鬆與平靜呼吸。';

  @override
  String get yogaDescDownwardDog => '基礎的倒 V 姿勢，伸展全身。';

  @override
  String get yogaDescPlank => '全身力量構建，參與核心、手臂和腿部。';

  @override
  String get yogaDescEightPoint => '強化力量的姿勢，放下胸部、下巴、膝蓋和腳趾。';

  @override
  String get yogaDescBabyCobra => '溫和的後彎，強化上背部和脊椎。';

  @override
  String get yogaDescFullCobra => '更強的開胸後彎，全身參與。';

  @override
  String get yogaDescSunSalutation => '連結呼吸與動作的動態序列。建立力量、熱量、協調性和耐力。';

  @override
  String get yogaInstHeadNeck =>
      '上下傾斜頭部，各保持 5-10 次呼吸。轉動頭部左右各 3 圈。將耳朵靠向肩膀，可用手輕輕輔助。';

  @override
  String get yogaInstStraightArms => '握拳，直臂向前旋轉 10 次，向後旋轉 10 次。';

  @override
  String get yogaInstBentArms => '雙肘在前方接觸，向上繞過頭後再向下。每個方向 10 圈。';

  @override
  String get yogaInstShouldersLateral => '右手垂向椅子，左臂向上舉過頭頂。保持 5-10 次呼吸，然後換邊。';

  @override
  String get yogaInstShouldersTorsoTwist => '舉起手臂，向右轉動軀幹，扶住椅子支撐。每側保持 5-10 次呼吸。';

  @override
  String get yogaInstLegRaiseBent => '保持背部挺直，抬起彎曲的腿。保持後受控放下。換腿。';

  @override
  String get yogaInstLegRaiseStraight => '抬起伸直的腿，盡可能長時間保持。放鬆並換腿。';

  @override
  String get yogaInstGoddessTwist => '雙膝張開，向側面伸展軀幹。保持 5-10 次呼吸，換邊。';

  @override
  String get yogaInstGoddessStrength => '在女神式站姿中將大腿抬離椅子。保持 5-10 次呼吸。重複。';

  @override
  String get yogaInstBackChestStretch => '扶住椅子，鉸鏈式下折呈 L 型，保持背部平坦。保持 5-10 次呼吸。';

  @override
  String get yogaInstStandingCrunch => '從 L 型開始，吸氣時腿向後伸展，呼氣時膝蓋向前收縮。重複。';

  @override
  String get yogaInstWarrior3 => '手離開椅子，保持平衡。換腿並重複。';

  @override
  String get yogaInstWarrior1 => '向後邁步，彎曲前膝，舉起雙臂。保持 5-10 次呼吸。';

  @override
  String get yogaInstWarrior2 => '腳趾轉向外側，伸展手臂，看向前方。保持。';

  @override
  String get yogaInstTriangle => '伸直前腿，手向下觸碰腳踝或瑜珈磚，另一手向上伸展。';

  @override
  String get yogaInstReverseWarrior => '向後傾斜時，上方手臂劃過頭頂。保持。';

  @override
  String get yogaInstSideAngle => '手降至腳內側，上方手臂沿對角線向頭頂上方延伸。';

  @override
  String get yogaInstGentleBreathing => '放鬆肩膀，雙手放在大腿上，用鼻子緩慢呼吸。';

  @override
  String get yogaInstDownwardDog => '雙手與肩同寬，雙腳與髖同寬。抬高臀部，胸部向大腿方向下壓。保持 5-10 次呼吸。';

  @override
  String get yogaInstPlank => '肩膀位於手腕正上方，收緊核心，身體從頭到腳跟成一直線。保持 5-10 次呼吸。';

  @override
  String get yogaInstEightPoint => '從四足跪姿開始，放低胸部和下巴至墊上，臀部保持抬高。保持 5-10 次呼吸。';

  @override
  String get yogaInstBabyCobra => '俯臥，輕輕推起胸部，手肘夾緊身體，肩膀遠離耳朵。保持 5-10 次呼吸。';

  @override
  String get yogaInstFullCobra => '伸直手肘，進一步抬高胸部，不要聳肩。保持 5-10 次呼吸。';

  @override
  String get yogaInstGentleBreathingIntermediate =>
      '雙手放在腹部或大腿上，放鬆肩膀，用鼻子緩慢自然地呼吸。';

  @override
  String get yogaInstSunSalutation =>
      '此流動序列連續重複——一呼一吸配合一個動作。\n 1. 吸氣 — 下犬式\n 抬高臀部，拉長脊椎。\n 2. 呼氣 — 板式\n 向前移動進入強壯的板式位置。\n 3. 吸氣 — 膝胸叩首（八點式）\n 受控下降，臀部抬高。\n 4. 呼氣 — 小眼鏡蛇式\n 輕輕抬起胸部，手肘靠近身體。\n 5. 吸氣 — 眼鏡蛇式\n 稍稍伸直手臂，打開胸腔。\n 6. 呼氣 — 回到下犬式\n 向後壓回倒 V 字型。\n 重複 5-10 輪或根據您的能力進行。';

  @override
  String get yogaGentleBreathingAdvanced => '通過鼻子柔和呼吸，拉長呼氣。讓全身沉靜並放鬆。';

  @override
  String get yogaModMoveSlowly => '動作緩慢';

  @override
  String get yogaModStopDizzy => '若感到暈眩請停止';

  @override
  String get yogaModChairSupport => '使用椅背支撐';

  @override
  String get yogaModElbowsStraight => '保持手肘伸直';

  @override
  String get yogaModControlledMove => '動作平穩且受控';

  @override
  String get yogaModFingersShoulders => '手指保持在肩膀上';

  @override
  String get yogaModSlowRolls => '緩慢且受控地轉動';

  @override
  String get yogaModButtocksDown => '保持臀部坐穩';

  @override
  String get yogaModFaceForward => '面向前方';

  @override
  String get yogaModHipsStable => '保持髖部穩定';

  @override
  String get yogaModShouldersLevel => '保持雙肩齊平';

  @override
  String get yogaModBackStraight => '保持背部挺直';

  @override
  String get yogaModBeginBent => '從屈膝版本開始';

  @override
  String get yogaModUseChairForSupport => '使用椅子支撐';

  @override
  String get yogaModKneesToes => '膝蓋與腳趾對齊';

  @override
  String get yogaModHipsGrounded => '保持臀部貼地/貼椅';

  @override
  String get yogaModTorsoUpright => '保持軀幹挺直';

  @override
  String get yogaModChairBalance => '使用椅子保持平衡';

  @override
  String get yogaModArmsLegsStraight => '保持手臂和腿部伸直';

  @override
  String get yogaModEngageCore => '收緊核心';

  @override
  String get yogaModAvoidPregnancy => '懷孕期間請避免';

  @override
  String get yogaModOneHandChair => '保持一隻手扶著椅子';

  @override
  String get yogaModStraightLine => '保持身體呈一直線';

  @override
  String get yogaModShortenStance => '縮短站距';

  @override
  String get yogaModSquareHips => '擺正髖部';

  @override
  String get yogaModLevelShoulders => '水平肩膀';

  @override
  String get yogaModUseBlock => '使用瑜珈磚';

  @override
  String get yogaModHipsForward => '保持髖部朝前';

  @override
  String get yogaModFrontKneeBent => '保持前膝彎曲';

  @override
  String get yogaModGazeDirection => '選擇凝視方向';

  @override
  String get yogaModTuckTailbone => '輕微收尾骨';

  @override
  String get yogaModSitOrLieDown => '坐下或躺下';

  @override
  String get yogaModCloseEyesIfComfortable => '若感覺舒適可閉上眼睛';

  @override
  String get yogaModBendKnees => '若腿筋緊繃可彎曲膝蓋';

  @override
  String get yogaModHeelsLifted => '練習時腳跟抬起';

  @override
  String get yogaModLowerKnees => '放下膝蓋以進行溫和版本';

  @override
  String get yogaModFeetTogether => '雙腳併攏以增加挑戰';

  @override
  String get yogaModSlowControl => '緩慢受控下降以保護肩膀';

  @override
  String get yogaModLiftPalms => '抬起手掌以增加挑戰';

  @override
  String get yogaModPressFeet => '雙腳向下踩實以增加穩定性';

  @override
  String get yogaModNoLockElbows => '不要鎖死手肘';

  @override
  String get yogaModTuckStomach => '輕微收腹以支持脊椎';

  @override
  String get yogaModRestChildPose => '如有需要，在兩輪之間於嬰兒式休息';

  @override
  String get yogaModSlowTransitions => '如果呼吸變得吃力，請放慢過渡動作';

  @override
  String get yogaModBendDownwardDog => '在下犬式中彎曲膝蓋以增加舒適感';

  @override
  String get yogaModSitOrLie => '坐直或平躺';

  @override
  String get yogaModCushionUnderKnees => '在膝蓋下放置墊子';

  @override
  String get sessionLevelLabel => '難度等級';

  @override
  String get sessionTotalTimeLabel => '總時長';

  @override
  String get sessionTotalPosesLabel => '總姿勢數';

  @override
  String get aboutThisSession => '課程簡介';

  @override
  String get posesPreview => '姿勢預覽';

  @override
  String posesCompletedCount(int completed, int total) {
    return '已完成 $completed / $total 個姿勢';
  }

  @override
  String get practiceAgain => '再次練習';

  @override
  String get posesLabel => '個姿勢';

  @override
  String get duration => '時長';

  @override
  String get poses => '姿勢';

  @override
  String get intensity => '強度';

  @override
  String get low => '低';

  @override
  String get aboutSession => '關於課程';

  @override
  String get sessionOverview => '課程概覽';

  @override
  String get joinClass => '參加課程';

  @override
  String dayNumber(int number) {
    return '第 $number 天';
  }

  @override
  String minsLabel(int count) {
    return '$count 分鐘';
  }

  @override
  String get completeCurrentPoseFirst => '請先完成目前的動作！';

  @override
  String get poseComplete => '動作完成！';

  @override
  String get greatWorkChoice => '做得好！接下來您想做什麼？';

  @override
  String get retryPose => '再做一次';

  @override
  String get nextPose => '下一個姿勢';

  @override
  String get finishSession => '結束課程';

  @override
  String get sessionComplete => '課程完成！';

  @override
  String completedPoses(int count) {
    return '已完成 $count 個動作';
  }

  @override
  String totalMinutesSpent(int value, String unit) {
    return '您已練習了 $value $unit';
  }

  @override
  String get totaltime => '總練習時長：';

  @override
  String get howToPose => '動作指南';

  @override
  String get sessionPlaylist => '課程列表';

  @override
  String get playing => '播放中';

  @override
  String get pause => '暫停';

  @override
  String get resume => '繼續';

  @override
  String get waitingForPin => '等待輸入密碼...';

  @override
  String get exitSessionTitle => '退出練習？';

  @override
  String posesCompletedInfo(int completed, int total) {
    return '已完成 $completed / $total 個動作';
  }

  @override
  String get progressSaved => '進度已保存 ✓';

  @override
  String get continueLater => '您可以隨時回來繼續練習！';

  @override
  String get noPosesCompleted => '尚未完成任何動作';

  @override
  String get completeOneToSave => '請至少完成一個動作以保存您的進度。';

  @override
  String get stayButton => '繼續練習';

  @override
  String get playbackNormal => '正常';

  @override
  String poseProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get videoTutorial => '影片教學';

  @override
  String get safetyTips => '安全提示';

  @override
  String get tip1 => '保持膝蓋微屈以避免關節受壓';

  @override
  String get tip2 => '在整個姿勢中收緊核心肌肉';

  @override
  String get tip3 => '不要強迫腳後跟觸地';

  @override
  String get tip4 => '深呼吸，避免憋氣';

  @override
  String get tip5 => '如果感到疼痛，請緩慢退出姿勢';

  @override
  String get markAsCompleted => '標記為已完成';

  @override
  String get completed => '已完成';

  @override
  String get poseMarkedSuccess => '姿勢已標記為完成！';

  @override
  String get completeSession => '完成課程';

  @override
  String get congratulations => '🎉 恭喜！';

  @override
  String get sessionCompleteDesc => '您已完成本課程中的所有姿勢！';

  @override
  String get done => '完成';

  @override
  String get poseDetailTitle => '姿勢詳情';

  @override
  String get howToDoTitle => '動作要領';

  @override
  String get learningNotice => '此處僅供學習參考。如需記錄進度，請從課程介面點擊「加入課程」。';

  @override
  String poseCurrentCount(int current, int total) {
    return '第 $current / $total 個';
  }

  @override
  String durationFormat(int minutes, String seconds) {
    return '$minutes:$seconds 分鐘';
  }

  @override
  String get calendar => '練習日曆';

  @override
  String get activitySummary => '活動摘要';

  @override
  String get totalMinutes => '總分鐘數';

  @override
  String get thisWeek => '本週進度';

  @override
  String get dailyMinutes => '每日時長';

  @override
  String get week => '週';

  @override
  String get nothingTracked => '暫無記錄';

  @override
  String get min => '分鐘';

  @override
  String ofGoal(int goal) {
    return '目標 $goal 分鐘';
  }

  @override
  String get weeklyBadges => '每週勳章';

  @override
  String get wellnessCheckIn => '健康打卡';

  @override
  String get checkedInThisWeek => '本週已打卡 ✓';

  @override
  String get howAreYouFeeling => '您今天感覺如何？';

  @override
  String get checkInButton => '開始打卡';

  @override
  String get historyButton => '查看歷史';

  @override
  String get practice => '練習日';

  @override
  String get restDay => '休息日';

  @override
  String get reflectionHistory => '感悟歷史';

  @override
  String get noReflections => '暫無感悟記錄';

  @override
  String get bodyComfort => '身體舒適度';

  @override
  String get flexibility => '靈活性';

  @override
  String get balance => '平衡力';

  @override
  String get energy => '精力水準';

  @override
  String get mood => '情緒狀態';

  @override
  String get confidence => '日常自信心';

  @override
  String get mindBody => '身心連接';

  @override
  String get wellbeing => '整體健康';

  @override
  String get notes => '備註：';

  @override
  String get wellnessDialogTitle => '健康打卡';

  @override
  String get wellnessDialogSubtitle => '請評估您過去一週的感受';

  @override
  String get qBodyComfort => '練習時身體感到舒適嗎？';

  @override
  String get qFlexibility => '您覺得最近身體變靈活了嗎？';

  @override
  String get qBalance => '平衡動作練習得穩嗎？';

  @override
  String get qEnergy => '您的精力水準如何？';

  @override
  String get qMood => '最近心情怎麼樣？';

  @override
  String get qConfidence => '日常生活中感到自信嗎？';

  @override
  String get qBodyConnection => '練習時能感受到身心連接嗎？';

  @override
  String get qOverall => '總體而言，您對目前的健康狀況滿意嗎？';

  @override
  String get notesOptional => '備註（選填）';

  @override
  String get cancel => '取消';

  @override
  String get submit => '提交';

  @override
  String get rateAllError => '請評價所有項目後再提交';

  @override
  String get checkInSaved => '健康打卡已儲存！';

  @override
  String get platinum => '鉑金';

  @override
  String get gold => '黃金';

  @override
  String get silver => '白銀';

  @override
  String get bronze => '青銅';

  @override
  String get none => '無';

  @override
  String get section1Title => '第一部分 – 身體舒適度與靈活性';

  @override
  String get section2Title => '第二部分 – 精力與情緒';

  @override
  String get section3Title => '第三部分 – 覺知與自信';

  @override
  String get section4Title => '⭐ 整體健康';

  @override
  String get qBodyComfortFull => '1️⃣ 運動時身體感覺有多舒適？';

  @override
  String get optComfort1 => '不舒適';

  @override
  String get optComfort2 => '略微舒適';

  @override
  String get optComfort3 => '中度舒適';

  @override
  String get optComfort4 => '非常舒適';

  @override
  String get optComfort5 => '極其舒適';

  @override
  String get qFlexibilityFull => '2️⃣ 您如何描述最近的靈活性？';

  @override
  String get optFlexibility1 => '僵硬得多';

  @override
  String get optFlexibility2 => '有點僵硬';

  @override
  String get optFlexibility3 => '差不多';

  @override
  String get optFlexibility4 => '更有彈性了';

  @override
  String get optFlexibility5 => '靈活得多';

  @override
  String get qBalanceFull => '3️⃣ 站立或平衡時感覺穩嗎？';

  @override
  String get optBalance1 => '一點也不穩';

  @override
  String get optBalance2 => '略微穩當';

  @override
  String get optBalance3 => '中度穩當';

  @override
  String get optBalance4 => '非常穩當';

  @override
  String get optBalance5 => '極其穩當';

  @override
  String get qEnergyFull => '4️⃣ 您的整體精力水準如何？';

  @override
  String get optEnergy1 => '非常低';

  @override
  String get optEnergy2 => '低';

  @override
  String get optEnergy3 => '一般';

  @override
  String get optEnergy4 => '良好';

  @override
  String get optEnergy5 => '非常好';

  @override
  String get qMoodFull => '5️⃣ 最近的心情怎麼樣？';

  @override
  String get optMood1 => '經常感到壓力或沮喪';

  @override
  String get optMood2 => '有時感到壓力';

  @override
  String get optMood3 => '大多還好';

  @override
  String get optMood4 => '大多積極';

  @override
  String get optMood5 => '非常積極和平靜';

  @override
  String get qConfidenceFull => '6️⃣ 進行日常活動時感覺有多自信？';

  @override
  String get optConfidence1 => '不自信';

  @override
  String get optConfidence2 => '略微自信';

  @override
  String get optConfidence3 => '有些自信';

  @override
  String get optConfidence4 => '自信';

  @override
  String get optConfidence5 => '非常自信';

  @override
  String get qBodyConnectionFull => '7️⃣ 練習瑜伽時與身體的連接感如何？';

  @override
  String get optConnection1 => '沒有連接感';

  @override
  String get optConnection2 => '有一點連接感';

  @override
  String get optConnection3 => '中度連接感';

  @override
  String get optConnection4 => '非常有連接感';

  @override
  String get optConnection5 => '深度連接';

  @override
  String get qOverallFull => '8️⃣ 總體而言，您如何評價本月的健康狀況？';

  @override
  String get optOverall1 => '較差';

  @override
  String get optOverall2 => '一般';

  @override
  String get optOverall3 => '好';

  @override
  String get optOverall4 => '非常好';

  @override
  String get optOverall5 => '極好';

  @override
  String get monthlyReflections => '💭 每月感悟（選填）';

  @override
  String get shareImprovements => '分享您注意到的具體進步：';

  @override
  String get labelBalance => '🧘 平衡力提升';

  @override
  String get hintBalance => '例如：我可以單腳站立更久了...';

  @override
  String get labelPosture => '🪑 體態改善';

  @override
  String get hintPosture => '例如：我的背感覺更直了...';

  @override
  String get labelConsistency => '📅 堅持與習慣';

  @override
  String get hintConsistency => '例如：我現在每天早上都練習...';

  @override
  String get labelOther => '💬 其他想法';

  @override
  String get hintOther => '任何其他進步或筆記...';

  @override
  String get skipForNow => '暫時跳過';

  @override
  String get submitCheckIn => '提交打卡';

  @override
  String get validationErrorCheckIn => '提交前請回答所有必填問題';

  @override
  String get nowPlaying => '正在播放';

  @override
  String get moreDetails => '更多詳情';

  @override
  String get aboutThisSound => '關於此聲音';

  @override
  String get category => '類別';

  @override
  String get type => '類型';

  @override
  String get meditationType => '冥想與放鬆';

  @override
  String get benefits => '益處';

  @override
  String get soundBenefit1 => '• 減輕壓力和焦慮';

  @override
  String get soundBenefit2 => '• 提高注意力和專注力';

  @override
  String get soundBenefit3 => '• 促進更好的睡眠';

  @override
  String get soundBenefit4 => '• 提升整體幸福感';

  @override
  String get meditationHeader => '冥想與白噪音';

  @override
  String get quickStart => '快速開始';

  @override
  String get guidedMeditationSection => '引導式冥想';

  @override
  String get ambientSoundsSection => '大自然的聲音';

  @override
  String get ambientSoundsSubtitle => '純淨的大自然聲音助您放鬆';

  @override
  String get morningClarityTitle => '晨間清爽';

  @override
  String get morningClarityDesc => '開啟充滿寧靜與力量的一天';

  @override
  String get deepBreathingTitle => '深呼吸練習';

  @override
  String get deepBreathingDesc => '通過專注呼吸緩解壓力';

  @override
  String get eveningWindDownTitle => '晚間放鬆';

  @override
  String get eveningWindDownDesc => '卸下疲憊，準備進入夢鄉';

  @override
  String get oceanWavesTitle => '海浪聲';

  @override
  String get oceanWavesDesc => '海浪拍打沙灘的柔和聲';

  @override
  String get rainSoundsTitle => '雨聲';

  @override
  String get rainSoundsDesc => '淅瀝的雨聲與悶雷';

  @override
  String get forestBirdsTitle => '森林鳥鳴';

  @override
  String get forestBirdsDesc => '置身於大自然的鳥語花香';

  @override
  String get cracklingFireTitle => '木柴燃燒聲';

  @override
  String get cracklingFireDesc => '壁爐火堆的溫暖聲';

  @override
  String get whiteNoiseTitle => '白噪音';

  @override
  String get whiteNoiseDesc => '純淨白噪音，助力專注';

  @override
  String get flowingWaterTitle => '流水潺潺';

  @override
  String get flowingWaterDesc => '溪水流過的清脆聲';

  @override
  String get windChimesTitle => '清脆風鈴';

  @override
  String get windChimesDesc => '寧靜祥和的風鈴聲';

  @override
  String get nightCricketsTitle => '夏夜蟲鳴';

  @override
  String get nightCricketsDesc => '寧靜夜晚的蛐蛐叫聲';

  @override
  String get meditationHeaderTitle => '選擇您的冥想課程';

  @override
  String get meditationHeaderSubtitle => '停下來，深呼吸';

  @override
  String get meditationQuickStart => '快速開始 • 5-10 分鐘';

  @override
  String get meditationAllSection => '所有冥想';

  @override
  String get meditationCategoryLabel => '冥想';

  @override
  String meditationDurationMin(int count) {
    return '$count 分鐘';
  }

  @override
  String get meditationSessionMorningTitle => '晨間清透';

  @override
  String get meditationSessionMorningDesc => '以平和的心境開啟新的一天';

  @override
  String get meditationSessionBreathingTitle => '深呼吸練習';

  @override
  String get meditationSessionBreathingDesc => '透過專注呼吸緩解壓力';

  @override
  String get meditationSessionEveningTitle => '睡前放鬆';

  @override
  String get meditationSessionEveningDesc => '放下疲憊，為休息做好準備';

  @override
  String get soundCategory => '環境音';

  @override
  String get meditationPreparing => '正在為您準備課程...';

  @override
  String get meditationCancel => '取消課程';

  @override
  String get meditationEndSession => '結束課程';

  @override
  String get meditationComplete => '課程已完成';

  @override
  String get meditationInhale => '吸氣...';

  @override
  String get meditationExhale => '呼氣...';

  @override
  String get meditationHold => '屏息...';

  @override
  String get meditationEndTitle => '結束課程？';

  @override
  String get meditationEndMessage => '您確定要結束目前的冥想課程嗎？';

  @override
  String get meditationConfirmEnd => '結束';

  @override
  String get profileTitle => '個人中心';

  @override
  String get edit => '編輯';

  @override
  String get minutesLabel => '分鐘';

  @override
  String get daily => '每日 🔥';

  @override
  String get streakSummary => '連續天數總結';

  @override
  String get weeklyActive => '每週活躍週數';

  @override
  String get preferences => '偏好設定';

  @override
  String get enabled => '已啟用';

  @override
  String get disabled => '已禁用';

  @override
  String get signout => '登出';

  @override
  String get aboutus => '關於我們';

  @override
  String get editProfile => '編輯個人資料';

  @override
  String get save => '儲存';

  @override
  String get uploadPhoto => '上傳照片';

  @override
  String get removePhoto => '移除照片';

  @override
  String get photoUpdated => '頭像已更新';

  @override
  String get photoRemoved => '頭像已移除';

  @override
  String get photoFail => '上傳失敗';

  @override
  String get basicInfo => '基本資訊';

  @override
  String get fullName => '全名';

  @override
  String get age => '年齡';

  @override
  String get experienceLevel => '經驗等級';

  @override
  String get sessionLength => '課程時長';

  @override
  String get language => '語言';

  @override
  String get notifications => '通知';

  @override
  String get pushNotifications => '推送通知';

  @override
  String get pushEnabledMsg => '推送通知已啟用！🔔';

  @override
  String get dailyReminder => '每日練習提醒';

  @override
  String get dailyReminderEnabled => '每日提醒已啟用！';

  @override
  String get dailyEnabledMsg => '我們每天都會提醒您練習。🌞';

  @override
  String get reminderTime => '提醒時間';

  @override
  String get dailyReminderNotification => '每日練習提醒';

  @override
  String get dailyReminderBody => '該做每日瑜伽練習了！🏃‍♀️';

  @override
  String get sound => '聲音';

  @override
  String get soundEffects => '音效';

  @override
  String get appVolume => '應用音量';

  @override
  String get systemVolume => '系統音量';

  @override
  String get appVolumeDesc => '調整應用內聲音的音量';

  @override
  String get systemVolumeDesc => '調整您的裝置系統音量';

  @override
  String get validationError => '姓名和年齡為必填項';

  @override
  String get beginner => '初學者';

  @override
  String get intermediate => '中級';

  @override
  String get advanced => '高級';

  @override
  String get min5 => '5 分鐘';

  @override
  String get min10 => '10 分鐘';

  @override
  String get min15 => '15 分鐘';

  @override
  String get min20 => '20 分鐘';

  @override
  String get min30 => '30 分鐘';

  @override
  String get english => '英文';

  @override
  String get mandarinSimplified => '簡體中文';

  @override
  String get mandarinTraditional => '繁體中文';

  @override
  String completedPosesCount(int count) {
    return '您完成了 $count 個姿勢！';
  }

  @override
  String get minutes => '分鐘';

  @override
  String get next => '下一步';

  @override
  String get aboutThisPose => '關於此姿勢';

  @override
  String get exitSession => '退出課程？';

  @override
  String get exitSessionMessage => '如果現在退出，您的進度將不會被儲存。確定要退出嗎？';

  @override
  String get exit => '退出';

  @override
  String get aboutUsTitle => '關於我們';

  @override
  String get appName => 'Zencore';

  @override
  String get appVersion => '版本 1.0.0';

  @override
  String get ourMission => '我們的使命';

  @override
  String get missionStatement => '通過溫和的椅子瑜伽、舒緩的冥想和正念練習，讓每個人都能享受健康生活。';

  @override
  String get projectTeam => '項目團隊';

  @override
  String get projectSupervisor => '項目主管';

  @override
  String get developmentTeam => '開發團隊';

  @override
  String get yogaInstructor => '瑜伽導師';

  @override
  String get keyFeatures => '核心功能';

  @override
  String get featureChairYoga => '椅子瑜伽課程';

  @override
  String get featureMeditation => '專業冥想指導';

  @override
  String get featureProgress => '進度跟蹤';

  @override
  String get featureSounds => '助眠舒緩音效';

  @override
  String get licensesTitle => '開源授權';

  @override
  String get licenseDescription => 'HealYoga 是使用開源軟體構建的。您可以在下方查看完整的許可列表。';

  @override
  String get viewLicensesButton => '查看所有授權';

  @override
  String get copyright => '© 2026 ZENCORE';

  @override
  String get allRightsReserved => '保留所有權利';
}
