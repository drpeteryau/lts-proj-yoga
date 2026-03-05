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
  String get yogaHeadNeckShoulders => '头、颈、肩拉伸';

  @override
  String get yogaStraightArms => '直臂转动';

  @override
  String get yogaBentArms => '屈臂转动';

  @override
  String get yogaShouldersLateral => '肩膀侧向拉伸';

  @override
  String get yogaShouldersTorsoTwist => '肩部与躯干扭转';

  @override
  String get yogaLegRaiseBent => '屈膝抬腿';

  @override
  String get yogaLegRaiseStraight => '直腿抬腿';

  @override
  String get yogaGoddessTwist => '女神式 — 躯干扭转';

  @override
  String get yogaGoddessStrength => '女神式 — 腿部强化';

  @override
  String get yogaBackChestStretch => '背部与胸部拉伸';

  @override
  String get yogaStandingCrunch => '站立仰卧起坐';

  @override
  String get yogaWarrior3Supported => '战士三式（支撑版）';

  @override
  String get yogaWarrior1Supported => '战士一式（支撑版）';

  @override
  String get yogaWarrior2Supported => '战士二式（支撑版）';

  @override
  String get yogaTriangleSupported => '三角式（支撑版）';

  @override
  String get yogaReverseWarrior2 => '反向战士二式';

  @override
  String get yogaSideAngleSupported => '侧角式（支撑版）';

  @override
  String get yogaGentleBreathing => '轻柔呼吸';

  @override
  String get yogaDownwardDog => '下犬式';

  @override
  String get yogaPlank => '板式';

  @override
  String get yogaEightPoint => '八点式 (Ashtangasana)';

  @override
  String get yogaBabyCobra => '眼镜蛇式（婴儿版）';

  @override
  String get yogaFullCobra => '眼镜蛇式（完整版）';

  @override
  String get yogaSunSalutation => '向日式流';

  @override
  String get yogaSessionGentleChair => '轻柔椅子瑜伽';

  @override
  String get yogaSessionMorningMobility => '晨间活动性练习';

  @override
  String get yogaSessionWarriorSeries => '战士系列';

  @override
  String get yogaSessionHathaFundamentals => '哈他基础';

  @override
  String get yogaSessionCoreStrength => '核心力量增强';

  @override
  String get yogaSessionBackbendFlow => '后弯流';

  @override
  String get yogaSessionSunSalutation => '向日式流';

  @override
  String get yogaSessionExtendedFlow => '扩展流练习';

  @override
  String get yogaDescHeadNeck => '轻柔的坐姿拉伸，缓解颈部和肩部紧张。';

  @override
  String get yogaDescGentleChair =>
      '确保椅子靠墙放置以保持稳定。初级椅子瑜伽适合大多数人。建议空腹或饭后至少 2 小时练习。';

  @override
  String get yogaDescMorningMobility => '轻松的晨间练习，专注于关节活动度、呼吸和辅助力量训练。';

  @override
  String get yogaDescWarriorSeries => '建立自信的序列，探索战士一、二式及辅助过渡动作。';

  @override
  String get yogaDescHathaFundamentals =>
      '经典的垫上哈他序列，专注于对位、呼吸和全身参与。适合准备脱离椅子辅助的练习者。';

  @override
  String get yogaDescCoreStrength => '简短而强大的课程，专注于板式、八点式和受控过渡。增强核心力量和肩部稳定性。';

  @override
  String get yogaDescBackbendFlow => '增强脊柱力量的序列，从八点式过渡到婴儿眼镜蛇和完整眼镜蛇式。建立后弯的信心。';

  @override
  String get yogaDescSunSalutationSession =>
      '动态垫上流练习，旨在同步呼吸与动作。通过重复的向日式循环增强耐力和全身力量。';

  @override
  String get yogaDescExtendedFlow =>
      '更深层、更长时间的向日式练习 —— 非常适合想要接受呼吸引导动作挑战的资深练习者。';

  @override
  String get yogaDescStraightArms => '手臂旋转练习，预热肩膀和上背部。';

  @override
  String get yogaDescBentArms => '屈肘肩部活动练习。';

  @override
  String get yogaDescShouldersLateral => '改善身体灵活性的侧向拉伸。';

  @override
  String get yogaDescShouldersTorsoTwist => '温和的排毒扭转动作。';

  @override
  String get yogaDescLegRaiseBent => '加强腿部力量并激活核心。';

  @override
  String get yogaDescLegRaiseStraight => '直腿抬高以获得更高级的力量训练。';

  @override
  String get yogaDescGoddessTwist => '宽腿坐姿以提高灵活性。';

  @override
  String get yogaDescGoddessStrength => '坐姿女神式的强化变体。';

  @override
  String get yogaDescBackChestStretch => 'L型拉伸，改善上半身灵活性。';

  @override
  String get yogaDescStandingCrunch => '动态核心强化动作。';

  @override
  String get yogaDescWarrior3Supported => '利用椅子辅助练习平衡与力量。';

  @override
  String get yogaDescWarrior1Supported => '适合初学者的战士站姿。';

  @override
  String get yogaDescWarrior2Supported => '侧向战士式，用于开胯。';

  @override
  String get yogaDescTriangleSupported => '深层侧面身体延展。';

  @override
  String get yogaDescReverseWarrior2 => '后拱战士拉伸。';

  @override
  String get yogaDescSideAngleSupported => '强化腿部并扩张肋骨。';

  @override
  String get yogaDescGentleBreathing => '全身放松与平静呼吸。';

  @override
  String get yogaDescDownwardDog => '基础的倒 V 姿势，拉伸全身。';

  @override
  String get yogaDescPlank => '锻炼核心、手臂和腿部的全身力量训练。';

  @override
  String get yogaDescEightPoint => '通过降低胸部、下巴、膝盖和脚趾来建立力量的姿势。';

  @override
  String get yogaDescBabyCobra => '温和的后弯，强化上背部和脊柱。';

  @override
  String get yogaDescFullCobra => '更有力的开胸后弯，调动全身。';

  @override
  String get yogaDescSunSalutation => '连接呼吸与动作的动态序列。建立力量、热量、协调性和耐力。';

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
  String get poseComplete => '姿势完成！';

  @override
  String get greatWorkChoice => '太棒了！您接下来想做什么？';

  @override
  String get retryPose => '重新练习此姿势';

  @override
  String get finishSession => '结束课程';

  @override
  String get sessionPlaylist => '课程列表';

  @override
  String get playing => '播放中';

  @override
  String poseCountProgress(int completed, int total) {
    return '$completed/$total';
  }

  @override
  String totalMinutesSpent(int minutes, String minutesLabel) {
    return '总计 $minutes $minutesLabel';
  }

  @override
  String get previous => '上一个';

  @override
  String get completeCurrentPoseFirst => '请在进入下一个姿势前完成当前练习';

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
  String get nextPose => '下一个姿势';

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
  String get soundOceanWaves => '海浪声';

  @override
  String get soundForestRain => '森林雨声';

  @override
  String get soundTibetanBowls => '西藏颂钵';

  @override
  String get soundPeacefulPiano => '宁静钢琴';

  @override
  String get soundMountainStream => '山间溪流';

  @override
  String get soundWindChimes => '风铃声';

  @override
  String get soundGentleThunder => '柔和雷声';

  @override
  String get soundSingingBirds => '鸟鸣声';

  @override
  String get categoryNature => '大自然';

  @override
  String get categoryMeditation => '冥想';

  @override
  String get categoryAmbient => '氛围音';

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
  String get sessionComplete => '课程完成！';

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
  String get appSubtitle => '通过引导瑜伽帮助您建立更健康的生活习惯。';

  @override
  String get missionTitle => '我们的使命';

  @override
  String get missionContent =>
      'HealYoga 旨在通过引导课程、舒缓音乐和进度追踪来鼓励规律的瑜伽练习。我们专注于易用性和简化流程，让每个人都能享受健康生活。';

  @override
  String get featuresTitle => '核心功能';

  @override
  String get feature1 => '引导式瑜伽课程';

  @override
  String get feature2 => '放松音乐与冥想';

  @override
  String get feature3 => '进度追踪';

  @override
  String get feature4 => '用户认证与个人资料';

  @override
  String get creditsTitle => '制作团队';

  @override
  String get projectSupervisor => '项目指导';

  @override
  String get teamMembers => '团队成员';

  @override
  String get yogaInstructor => '瑜伽导师';

  @override
  String get licensesTitle => '开源许可';

  @override
  String get viewLicensesButton => '查看所有许可';

  @override
  String get copyright => '© 2026 HealYoga 项目\n保留所有权利';
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
  String get yogaHeadNeckShoulders => '头、颈、肩拉伸';

  @override
  String get yogaStraightArms => '直臂转动';

  @override
  String get yogaBentArms => '屈臂转动';

  @override
  String get yogaShouldersLateral => '肩膀侧向拉伸';

  @override
  String get yogaShouldersTorsoTwist => '肩部与躯干扭转';

  @override
  String get yogaLegRaiseBent => '屈膝抬腿';

  @override
  String get yogaLegRaiseStraight => '直腿抬腿';

  @override
  String get yogaGoddessTwist => '女神式 — 躯干扭转';

  @override
  String get yogaGoddessStrength => '女神式 — 腿部强化';

  @override
  String get yogaBackChestStretch => '背部与胸部拉伸';

  @override
  String get yogaStandingCrunch => '站立仰卧起坐';

  @override
  String get yogaWarrior3Supported => '战士三式（支撑版）';

  @override
  String get yogaWarrior1Supported => '战士一式（支撑版）';

  @override
  String get yogaWarrior2Supported => '战士二式（支撑版）';

  @override
  String get yogaTriangleSupported => '三角式（支撑版）';

  @override
  String get yogaReverseWarrior2 => '反向战士二式';

  @override
  String get yogaSideAngleSupported => '侧角式（支撑版）';

  @override
  String get yogaGentleBreathing => '轻柔呼吸';

  @override
  String get yogaDownwardDog => '下犬式';

  @override
  String get yogaPlank => '板式';

  @override
  String get yogaEightPoint => '八点式 (Ashtangasana)';

  @override
  String get yogaBabyCobra => '眼镜蛇式（婴儿版）';

  @override
  String get yogaFullCobra => '眼镜蛇式（完整版）';

  @override
  String get yogaSunSalutation => '向日式流';

  @override
  String get yogaSessionGentleChair => '轻柔椅子瑜伽';

  @override
  String get yogaSessionMorningMobility => '晨间活动性练习';

  @override
  String get yogaSessionWarriorSeries => '战士系列';

  @override
  String get yogaSessionHathaFundamentals => '哈他基础';

  @override
  String get yogaSessionCoreStrength => '核心力量增强';

  @override
  String get yogaSessionBackbendFlow => '后弯流';

  @override
  String get yogaSessionSunSalutation => '向日式流';

  @override
  String get yogaSessionExtendedFlow => '扩展流练习';

  @override
  String get yogaDescHeadNeck => '轻柔的坐姿拉伸，缓解颈部和肩部紧张。';

  @override
  String get yogaDescGentleChair =>
      '确保椅子靠墙放置以保持稳定。初级椅子瑜伽适合大多数人。建议空腹或饭后至少 2 小时练习。';

  @override
  String get yogaDescMorningMobility => '轻松的晨间练习，专注于关节活动度、呼吸和辅助力量训练。';

  @override
  String get yogaDescWarriorSeries => '建立自信的序列，探索战士一、二式及辅助过渡动作。';

  @override
  String get yogaDescHathaFundamentals =>
      '经典的垫上哈他序列，专注于对位、呼吸和全身参与。适合准备脱离椅子辅助的练习者。';

  @override
  String get yogaDescCoreStrength => '简短而强大的课程，专注于板式、八点式和受控过渡。增强核心力量和肩部稳定性。';

  @override
  String get yogaDescBackbendFlow => '增强脊柱力量的序列，从八点式过渡到婴儿眼镜蛇和完整眼镜蛇式。建立后弯的信心。';

  @override
  String get yogaDescSunSalutationSession =>
      '动态垫上流练习，旨在同步呼吸与动作。通过重复的向日式循环增强耐力和全身力量。';

  @override
  String get yogaDescExtendedFlow =>
      '更深层、更长时间的向日式练习 —— 非常适合想要接受呼吸引导动作挑战的资深练习者。';

  @override
  String get yogaDescStraightArms => '手臂旋转练习，预热肩膀和上背部。';

  @override
  String get yogaDescBentArms => '屈肘肩部活动练习。';

  @override
  String get yogaDescShouldersLateral => '改善身体灵活性的侧向拉伸。';

  @override
  String get yogaDescShouldersTorsoTwist => '温和的排毒扭转动作。';

  @override
  String get yogaDescLegRaiseBent => '加强腿部力量并激活核心。';

  @override
  String get yogaDescLegRaiseStraight => '直腿抬高以获得更高级的力量训练。';

  @override
  String get yogaDescGoddessTwist => '宽腿坐姿以提高灵活性。';

  @override
  String get yogaDescGoddessStrength => '坐姿女神式的强化变体。';

  @override
  String get yogaDescBackChestStretch => 'L型拉伸，改善上半身灵活性。';

  @override
  String get yogaDescStandingCrunch => '动态核心强化动作。';

  @override
  String get yogaDescWarrior3Supported => '利用椅子辅助练习平衡与力量。';

  @override
  String get yogaDescWarrior1Supported => '适合初学者的战士站姿。';

  @override
  String get yogaDescWarrior2Supported => '侧向战士式，用于开胯。';

  @override
  String get yogaDescTriangleSupported => '深层侧面身体延展。';

  @override
  String get yogaDescReverseWarrior2 => '后拱战士拉伸。';

  @override
  String get yogaDescSideAngleSupported => '强化腿部并扩张肋骨。';

  @override
  String get yogaDescGentleBreathing => '全身放松与平静呼吸。';

  @override
  String get yogaDescDownwardDog => '基础的倒 V 姿势，拉伸全身。';

  @override
  String get yogaDescPlank => '锻炼核心、手臂和腿部的全身力量训练。';

  @override
  String get yogaDescEightPoint => '通过降低胸部、下巴、膝盖和脚趾来建立力量的姿势。';

  @override
  String get yogaDescBabyCobra => '温和的后弯，强化上背部和脊柱。';

  @override
  String get yogaDescFullCobra => '更有力的开胸后弯，调动全身。';

  @override
  String get yogaDescSunSalutation => '连接呼吸与动作的动态序列。建立力量、热量、协调性和耐力。';

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
  String get poseComplete => '姿势完成！';

  @override
  String get greatWorkChoice => '太棒了！您接下来想做什么？';

  @override
  String get retryPose => '重新练习此姿势';

  @override
  String get finishSession => '结束课程';

  @override
  String get sessionPlaylist => '课程列表';

  @override
  String get playing => '播放中';

  @override
  String poseCountProgress(int completed, int total) {
    return '$completed/$total';
  }

  @override
  String totalMinutesSpent(int minutes, String minutesLabel) {
    return '总计 $minutes $minutesLabel';
  }

  @override
  String get previous => '上一个';

  @override
  String get completeCurrentPoseFirst => '请在进入下一个姿势前完成当前练习';

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
  String get nextPose => '下一个姿势';

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
  String get soundOceanWaves => '海浪声';

  @override
  String get soundForestRain => '森林雨声';

  @override
  String get soundTibetanBowls => '西藏颂钵';

  @override
  String get soundPeacefulPiano => '宁静钢琴';

  @override
  String get soundMountainStream => '山间溪流';

  @override
  String get soundWindChimes => '风铃声';

  @override
  String get soundGentleThunder => '柔和雷声';

  @override
  String get soundSingingBirds => '鸟鸣声';

  @override
  String get categoryNature => '大自然';

  @override
  String get categoryMeditation => '冥想';

  @override
  String get categoryAmbient => '氛围音';

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
  String get sessionComplete => '课程完成！';

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
  String get appSubtitle => '通过引导瑜伽帮助您建立更健康的生活习惯。';

  @override
  String get missionTitle => '我们的使命';

  @override
  String get missionContent =>
      'HealYoga 旨在通过引导课程、舒缓音乐和进度追踪来鼓励规律的瑜伽练习。我们专注于易用性和简化流程，让每个人都能享受健康生活。';

  @override
  String get featuresTitle => '核心功能';

  @override
  String get feature1 => '引导式瑜伽课程';

  @override
  String get feature2 => '放松音乐与冥想';

  @override
  String get feature3 => '进度追踪';

  @override
  String get feature4 => '用户认证与个人资料';

  @override
  String get creditsTitle => '制作团队';

  @override
  String get projectSupervisor => '项目指导';

  @override
  String get teamMembers => '团队成员';

  @override
  String get yogaInstructor => '瑜伽导师';

  @override
  String get licensesTitle => '开源许可';

  @override
  String get viewLicensesButton => '查看所有许可';

  @override
  String get copyright => '© 2026 HealYoga 项目\n保留所有权利';
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
  String get yogaHeadNeckShoulders => '頭、頸、肩拉伸';

  @override
  String get yogaStraightArms => '直臂轉動';

  @override
  String get yogaBentArms => '屈臂轉動';

  @override
  String get yogaShouldersLateral => '肩膀側向拉伸';

  @override
  String get yogaShouldersTorsoTwist => '肩部與軀幹扭轉';

  @override
  String get yogaLegRaiseBent => '屈膝抬腿';

  @override
  String get yogaLegRaiseStraight => '直腿抬腿';

  @override
  String get yogaGoddessTwist => '女神式 — 軀幹扭轉';

  @override
  String get yogaGoddessStrength => '女神式 — 腿部強化';

  @override
  String get yogaBackChestStretch => '背部與胸部拉伸';

  @override
  String get yogaStandingCrunch => '站立仰臥起坐';

  @override
  String get yogaWarrior3Supported => '戰士三式（支撐版）';

  @override
  String get yogaWarrior1Supported => '戰士一式（支撐版）';

  @override
  String get yogaWarrior2Supported => '戰士二式（支撐版）';

  @override
  String get yogaTriangleSupported => '三角式（支撐版）';

  @override
  String get yogaReverseWarrior2 => '反向戰士二式';

  @override
  String get yogaSideAngleSupported => '側角式（支撐版）';

  @override
  String get yogaGentleBreathing => '輕柔呼吸';

  @override
  String get yogaDownwardDog => '下犬式';

  @override
  String get yogaPlank => '板式';

  @override
  String get yogaEightPoint => '八點式 (Ashtangasana)';

  @override
  String get yogaBabyCobra => '眼鏡蛇式（嬰兒版）';

  @override
  String get yogaFullCobra => '眼鏡蛇式（完整版）';

  @override
  String get yogaSunSalutation => '向日式流';

  @override
  String get yogaSessionGentleChair => '輕柔椅子瑜伽';

  @override
  String get yogaSessionMorningMobility => '晨間活動性練習';

  @override
  String get yogaSessionWarriorSeries => '戰士系列';

  @override
  String get yogaSessionHathaFundamentals => '哈他基礎';

  @override
  String get yogaSessionCoreStrength => '核心力量增強';

  @override
  String get yogaSessionBackbendFlow => '後彎流';

  @override
  String get yogaSessionSunSalutation => '向日式流';

  @override
  String get yogaSessionExtendedFlow => '擴展流練習';

  @override
  String get yogaDescHeadNeck => '輕柔的坐姿拉伸，緩解頸部和肩部緊張。';

  @override
  String get yogaDescGentleChair =>
      '確保椅子靠牆放置以保持穩定。初級椅子瑜伽適合大多數人。建議空腹或飯後至少 2 小時練習。';

  @override
  String get yogaDescMorningMobility => '輕鬆的晨間練習，專注於關節活動度、呼吸和輔助力量訓練。';

  @override
  String get yogaDescWarriorSeries => '建立自信的序列，探索戰士一、二式及輔助過渡動作。';

  @override
  String get yogaDescHathaFundamentals =>
      '經典的墊上哈他序列，專注於對位、呼吸和全身參與。適合準備脫離椅子輔助的練習者。';

  @override
  String get yogaDescCoreStrength => '簡短而強大的課程，專注於板式、八點式和受控過渡。增強核心力量和肩部穩定性。';

  @override
  String get yogaDescBackbendFlow => '增強脊椎力量的序列，從八點式過渡到嬰兒眼鏡蛇和完整眼鏡蛇式。建立後彎的信心。';

  @override
  String get yogaDescSunSalutationSession =>
      '動態墊上流練習，旨在同步呼吸與動作。透過重複的向日式循環增強耐力和全身力量。';

  @override
  String get yogaDescExtendedFlow =>
      '更深層、更長時間的向日式練習 —— 非常適合想要接受呼吸引導動作挑戰的資深練習者。';

  @override
  String get yogaDescStraightArms => '手臂旋轉練習，預熱肩膀和上背部。';

  @override
  String get yogaDescBentArms => '屈肘肩部活動練習。';

  @override
  String get yogaDescShouldersLateral => '改善身體靈活性的側向拉伸。';

  @override
  String get yogaDescShouldersTorsoTwist => '溫和的排毒扭轉動作。';

  @override
  String get yogaDescLegRaiseBent => '加強腿部力量並激活核心。';

  @override
  String get yogaDescLegRaiseStraight => '直腿抬高以獲得更高級的力量訓練。';

  @override
  String get yogaDescGoddessTwist => '寬腿坐姿以提高靈活性。';

  @override
  String get yogaDescGoddessStrength => '坐姿女神式的強化變體。';

  @override
  String get yogaDescBackChestStretch => 'L型拉伸，改善上半身靈活性。';

  @override
  String get yogaDescStandingCrunch => '動態核心強化動作。';

  @override
  String get yogaDescWarrior3Supported => '利用椅子輔助練習平衡與力量。';

  @override
  String get yogaDescWarrior1Supported => '適合初學者的戰士站姿。';

  @override
  String get yogaDescWarrior2Supported => '側向戰士式，用於開胯。';

  @override
  String get yogaDescTriangleSupported => '深層側面身體延展。';

  @override
  String get yogaDescReverseWarrior2 => '後拱戰士拉伸。';

  @override
  String get yogaDescSideAngleSupported => '強化腿部並擴張肋骨。';

  @override
  String get yogaDescGentleBreathing => '全身放鬆與平靜呼吸。';

  @override
  String get yogaDescDownwardDog => '基礎的倒 V 姿勢，拉伸全身。';

  @override
  String get yogaDescPlank => '鍛鍊核心、手臂和腿部的全身力量訓練。';

  @override
  String get yogaDescEightPoint => '透過降低胸部、下巴、膝蓋和腳趾來建立力量的姿勢。';

  @override
  String get yogaDescBabyCobra => '溫和的後彎，強化上背部和脊椎。';

  @override
  String get yogaDescFullCobra => '更有力的開胸後彎，調動全身。';

  @override
  String get yogaDescSunSalutation => '連接呼吸與動作的動態序列。建立力量、熱量、協調性和耐力。';

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
  String get poseComplete => '姿勢完成！';

  @override
  String get greatWorkChoice => '太棒了！您接下來想做什麼？';

  @override
  String get retryPose => '重新練習此姿勢';

  @override
  String get finishSession => '結束課程';

  @override
  String get sessionPlaylist => '課程列表';

  @override
  String get playing => '播放中';

  @override
  String poseCountProgress(int completed, int total) {
    return '$completed/$total';
  }

  @override
  String totalMinutesSpent(int minutes, String minutesLabel) {
    return '總計 $minutes $minutesLabel';
  }

  @override
  String get previous => '上一個';

  @override
  String get completeCurrentPoseFirst => '請在進入下一個姿勢前完成當前練習';

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
  String get nextPose => '下一個姿勢';

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
  String get soundOceanWaves => '海浪聲';

  @override
  String get soundForestRain => '森林雨聲';

  @override
  String get soundTibetanBowls => '西藏頌缽';

  @override
  String get soundPeacefulPiano => '寧靜鋼琴';

  @override
  String get soundMountainStream => '山間溪流';

  @override
  String get soundWindChimes => '風鈴聲';

  @override
  String get soundGentleThunder => '柔和雷聲';

  @override
  String get soundSingingBirds => '鳥鳴聲';

  @override
  String get categoryNature => '大自然';

  @override
  String get categoryMeditation => '冥想';

  @override
  String get categoryAmbient => '環境音';

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
  String get sessionComplete => '課程完成！';

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
  String get appSubtitle => '透過引導瑜伽幫助您建立更健康的生活習慣。';

  @override
  String get missionTitle => '我們的使命';

  @override
  String get missionContent =>
      'HealYoga 旨在透過引導課程、舒緩音樂和進度追蹤來鼓勵規律的瑜伽練習。我們專注於易用性和簡化流程，讓每個人都能享受健康生活。';

  @override
  String get featuresTitle => '核心功能';

  @override
  String get feature1 => '引導式瑜伽課程';

  @override
  String get feature2 => '放鬆音樂與冥想';

  @override
  String get feature3 => '進度追蹤';

  @override
  String get feature4 => '使用者認證與個人資料';

  @override
  String get creditsTitle => '製作團隊';

  @override
  String get projectSupervisor => '專案指導';

  @override
  String get teamMembers => '團隊成員';

  @override
  String get yogaInstructor => '瑜伽導師';

  @override
  String get licensesTitle => '開源授權';

  @override
  String get viewLicensesButton => '查看所有授權';

  @override
  String get copyright => '© 2026 HealYoga 專案\n保留所有權利';
}
