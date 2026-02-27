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
  String get stepAccount => '账号安全';

  @override
  String get getToknowYou => '👋 让我们了解您';

  @override
  String get tellUsAbout => '请告诉我们一些关于您的信息';

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
  String get alreadyHaveAccount => '已有账号？立即登录';

  @override
  String get back => '返回';

  @override
  String get createAccount => '创建账号';

  @override
  String get nameHint => '请输入您的姓名';

  @override
  String get ageHint => '请输入您的年龄';

  @override
  String get emailHint => '您的邮箱地址';

  @override
  String get passwordHint => '最少8位：包含大小写字母、数字及特殊字符';

  @override
  String get errEmailEmpty => '请输入您的电子邮箱';

  @override
  String get errEmailInvalid => '请输入有效的电子邮箱地址';

  @override
  String get errPasswordEmpty => '请输入密码';

  @override
  String get errNameEmpty => '请输入您的姓名';

  @override
  String get errAgeEmpty => '请输入有效的年龄（仅限数字）';

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
  String get completeProfileSubtitle => '只需几个简单的细节，即可开启您的个性化瑜伽之旅。';

  @override
  String get preferredLanguage => '首选语言';

  @override
  String get enterValidAge => '请输入有效的年龄';

  @override
  String get profileCompleted => '资料设置完成 🌿';

  @override
  String saveProfileFailed(String error) {
    return '保存资料失败：$error';
  }

  @override
  String get enableNotifications => '开启通知';

  @override
  String get continueButton => '继续';

  @override
  String get under18 => '18岁以下';

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
  String get dontHaveAccount => '没有账号？立即注册';

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
  String get onboardingHeading => '身心更强大';

  @override
  String get onboardingDesc => '随时随地跟随世界顶级的\n瑜伽教练居家或在旅途中\n进行学习练习。';

  @override
  String get letsExplore => '开启探索之旅';

  @override
  String get navHome => '主页';

  @override
  String get navSessions => '课程';

  @override
  String get navProgress => '进度';

  @override
  String get navMeditation => '冥想';

  @override
  String get navProfile => '个人资料';

  @override
  String get goodMorning => '早上好';

  @override
  String get goodAfternoon => '下午好';

  @override
  String get goodEvening => '晚上好';

  @override
  String dayCount(int number) {
    return '第 $number 天';
  }

  @override
  String get mainSessionTitle => '只需 6 分钟\n完成 7 项练习';

  @override
  String get start => '开始';

  @override
  String get keepUpWork => '继续保持！';

  @override
  String minShort(int count) {
    return '$count 分钟';
  }

  @override
  String poseDurationSeconds(int seconds) {
    return '$seconds 秒';
  }

  @override
  String durationFormat(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String get mon => '周一';

  @override
  String get tue => '周二';

  @override
  String get wed => '周三';

  @override
  String get thu => '周四';

  @override
  String get fri => '周五';

  @override
  String get sat => '周六';

  @override
  String get sun => '周日';

  @override
  String get chooseYour => '选择您的';

  @override
  String get level => '难度等级';

  @override
  String get beginnerSubtitle => '椅子瑜伽';

  @override
  String get beginnerDesc => '适合刚开始瑜伽之旅的新手';

  @override
  String get intermediateSubtitle => '垫上哈他瑜伽';

  @override
  String get intermediateDesc => '通过挑战性序列增强力量';

  @override
  String get advancedSubtitle => '动态向日式流瑜伽';

  @override
  String get advancedDesc => '通过流动的序列挑战自我';

  @override
  String lockedLevelTitle(String levelName) {
    return '$levelName 已锁定';
  }

  @override
  String completeMore(int count) {
    return '还需完成 $count 个课程';
  }

  @override
  String completeSessionsToUnlock(int count) {
    return '再完成 $count 个课程即可解锁';
  }

  @override
  String get unlockIntermediateFirst => '请先解锁中级难度';

  @override
  String sessionsProgress(int current, int required) {
    return '$current / $required 课时';
  }

  @override
  String sessionsCompletedCount(int count) {
    return '已完成 $count 个课程';
  }

  @override
  String get errorLoadingProgress => '加载进度时出错';

  @override
  String get retry => '重试';

  @override
  String get ok => '确定';

  @override
  String get beginnerTitle => '初级课程';

  @override
  String get warmup => '热身阶段';

  @override
  String get mainPractice => '核心练习';

  @override
  String get cooldown => '放松阶段';

  @override
  String get viewDetails => '查看详情';

  @override
  String poseCount(int count) {
    return '$count 个体式';
  }

  @override
  String sessionsCompleted(int count) {
    return '已完成 $count 个课时';
  }

  @override
  String get intermediateTitle => '中级课程';

  @override
  String get hathaPractice => '哈他瑜伽练习';

  @override
  String get startSession => '开始练习';

  @override
  String get advancedTitle => '高级课程';

  @override
  String get dynamicFlowNotice => '动态流瑜伽练习。随呼吸而动。';

  @override
  String get advancedLabel => '高级';

  @override
  String minutesCount(int count) {
    return '$count 分钟';
  }

  @override
  String get highIntensity => '高强度';

  @override
  String get sunSalutationTitle => '向日式流';

  @override
  String get repeatRounds => '重复 5-10 轮 • 一呼一吸，一动一作';

  @override
  String get beginFlow => '开始练习';

  @override
  String get step1 => '1. 下犬式';

  @override
  String get step2 => '2. 板式';

  @override
  String get step3 => '3. 八体投地式';

  @override
  String get step4 => '4. 眼镜蛇式 (婴儿版)';

  @override
  String get step5 => '5. 眼镜蛇式 (完整版)';

  @override
  String get step6 => '6. 回到下犬式';

  @override
  String get yogaHeadNeckShoulders => '头颈肩拉伸';

  @override
  String get yogaStraightArms => '直臂转动';

  @override
  String get yogaBentArms => '屈臂转动';

  @override
  String get yogaShouldersLateral => '肩膀侧向拉伸';

  @override
  String get yogaShouldersTorsoTwist => '肩部与躯干转体';

  @override
  String get yogaLegRaiseBent => '屈膝抬腿';

  @override
  String get yogaLegRaiseStraight => '直腿抬腿';

  @override
  String get yogaGoddessTwist => '女神式 — 躯干转体';

  @override
  String get yogaGoddessStrength => '女神式 — 腿部力量训练';

  @override
  String get yogaBackChestStretch => '背部与胸部拉伸';

  @override
  String get yogaStandingCrunch => '站立仰卧起坐 (转体收腹)';

  @override
  String get yogaWarrior3Supported => '战士三式 (辅助支撑)';

  @override
  String get yogaWarrior1Supported => '战士一式 (辅助支撑)';

  @override
  String get yogaWarrior2Supported => '战士二式 (辅助支撑)';

  @override
  String get yogaTriangleSupported => '三角式 (辅助支撑)';

  @override
  String get yogaReverseWarrior2 => '反向战士二式';

  @override
  String get yogaSideAngleSupported => '侧角式 (辅助支撑)';

  @override
  String get yogaGentleBreathing => '平缓呼吸';

  @override
  String get yogaDownwardDog => '下犬式';

  @override
  String get yogaPlank => '平板支撑';

  @override
  String get yogaEightPoint => '八体投地式 (Ashtangasana)';

  @override
  String get yogaBabyCobra => '眼镜蛇小式';

  @override
  String get yogaFullCobra => '眼镜蛇全式';

  @override
  String get yogaSunSalutation => '太阳致敬式流瑜伽';

  @override
  String get yogaSessionGentleChair => '温和椅子瑜伽';

  @override
  String get yogaSessionMorningMobility => '晨间舒展活力';

  @override
  String get yogaSessionWarriorSeries => '战士系列课';

  @override
  String get yogaSessionHathaFundamentals => '哈他瑜伽基础';

  @override
  String get yogaSessionCoreStrength => '核心力量塑形';

  @override
  String get yogaSessionBackbendFlow => '后弯流瑜伽';

  @override
  String get yogaSessionSunSalutation => '太阳致敬式序列';

  @override
  String get yogaSessionExtendedFlow => '深度进阶流瑜伽';

  @override
  String get yogaDescHeadNeck => '温和的坐姿拉伸，旨在缓解颈部和肩部的紧张。';

  @override
  String get yogaDescGentleChair => '适合老年人或希望进行缓慢、有支撑练习的学习者。';

  @override
  String get yogaDescMorningMobility => '轻便的晨间练习，专注于关节灵活性、呼吸和辅助力量练习。';

  @override
  String get yogaDescWarriorSeries => '建立自信的序列，探索战士一、二式及其衔接过渡。';

  @override
  String get yogaDescHathaFundamentals =>
      '经典的垫上哈他序列，专注于体位正位、呼吸和全身参与。适合准备脱离椅子辅助的练习者。';

  @override
  String get yogaDescCoreStrength => '短小精悍的核心课程，专注于平板支撑、八体投地式及受控转换。提升核心与肩部稳定性。';

  @override
  String get yogaDescBackbendFlow => '脊柱强化序列，从八体投地式过渡到眼镜蛇式。建立后弯练习的信心。';

  @override
  String get yogaDescSunSalutationSession =>
      '动态垫上流瑜伽，旨在同步呼吸与动作。通过重复太阳致敬式循环建立耐力与全身力量。';

  @override
  String get yogaDescExtendedFlow =>
      '更深、更长的太阳致敬式练习——适合希望在呼吸主导的动作中迎接持续挑战的资深练习者。';

  @override
  String get yogaDescStraightArms => '通过手臂转动来热身肩膀和上背部。';

  @override
  String get yogaDescBentArms => '屈肘进行的肩部灵活性练习。';

  @override
  String get yogaDescShouldersLateral => '侧身拉伸，有效提高身体柔韧性。';

  @override
  String get yogaDescShouldersTorsoTwist => '温和的排毒扭转动作。';

  @override
  String get yogaDescLegRaiseBent => '加强腿部力量并激活核心肌群。';

  @override
  String get yogaDescLegRaiseStraight => '直腿抬升，用于进阶力量训练。';

  @override
  String get yogaDescGoddessTwist => '宽距坐姿，提高髋部与躯干灵活性。';

  @override
  String get yogaDescGoddessStrength => '坐姿女神式的加强版变体。';

  @override
  String get yogaDescBackChestStretch => 'L型拉伸，改善上半身的柔韧性。';

  @override
  String get yogaDescStandingCrunch => '动态核心强化练习。';

  @override
  String get yogaDescWarrior3Supported => '利用椅子辅助进行的平衡与力量练习。';

  @override
  String get yogaDescWarrior1Supported => '适合初学者的战士一式站姿。';

  @override
  String get yogaDescWarrior2Supported => '侧向战士式，用于开启髋部空间。';

  @override
  String get yogaDescTriangleSupported => '深度的侧身延展练习。';

  @override
  String get yogaDescReverseWarrior2 => '向后弯曲的战士式拉伸。';

  @override
  String get yogaDescSideAngleSupported => '强化腿部力量并开启肋骨空间。';

  @override
  String get yogaDescGentleBreathing => '全身放松与平静呼吸练习。';

  @override
  String get yogaDescDownwardDog => '基础的倒置V字型，伸展全身。';

  @override
  String get yogaDescPlank => '全身力量训练，动员核心、手臂和腿部。';

  @override
  String get yogaDescEightPoint => '通过降低胸部、下巴、膝盖和脚趾来增强力量的体式。';

  @override
  String get yogaDescBabyCobra => '温和的后弯，增强上背部和脊椎力量。';

  @override
  String get yogaDescFullCobra => '更强效的开胸后弯，调动全身参与。';

  @override
  String get yogaDescSunSalutation => '将呼吸与动作结合的动态序列，提升力量、热量、协调性与耐力。';

  @override
  String get duration => '时长';

  @override
  String get poses => '体式';

  @override
  String get intensity => '强度';

  @override
  String get low => '低';

  @override
  String get aboutSession => '关于课程';

  @override
  String get sessionOverview => '课程大纲';

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
  String poseProgress(int current, int total) {
    return '第 $current / $total 个体式';
  }

  @override
  String get videoTutorial => '视频教程';

  @override
  String get safetyTips => '安全提示';

  @override
  String get tip1 => '保持膝盖微屈，避免关节压力';

  @override
  String get tip2 => '在整个体式中保持核心肌肉收紧';

  @override
  String get tip3 => '不要强迫脚后跟接触地面';

  @override
  String get tip4 => '深呼吸，避免屏住呼吸';

  @override
  String get tip5 => '如果感到任何疼痛，请缓慢退出体式';

  @override
  String get markAsCompleted => '标记为已完成';

  @override
  String get completed => '已完成';

  @override
  String get poseMarkedSuccess => '体式已标记为完成！';

  @override
  String get nextPose => '下一个体式';

  @override
  String get completeSession => '完成练习';

  @override
  String get congratulations => '🎉 恭喜！';

  @override
  String get sessionCompleteDesc => '您已完成本节课的所有体式！';

  @override
  String get done => '完成';

  @override
  String get progressHeader => '您的进度';

  @override
  String get progressSubtitle => '记录您的健康之旅';

  @override
  String get dayStreak => '连续天数';

  @override
  String get totalMinutes => '总计分钟';

  @override
  String get thisWeek => '本周进度';

  @override
  String weeklyGoal(int goal) {
    return '目标：$goal 分钟';
  }

  @override
  String get weeklyBadges => '每周勋章';

  @override
  String get checkedInMsg => '本周已打卡 ✓';

  @override
  String get shareFeeling => '分享您今天的感受';

  @override
  String get newCheckIn => '开启打卡';

  @override
  String get viewHistory => '查看历史';

  @override
  String get calendar => '练习日历';

  @override
  String get practice => '练习日';

  @override
  String get restDay => '休息日';

  @override
  String get wellnessDialogTitle => '身心健康打卡';

  @override
  String get wellnessDialogSubtitle => '您今天感觉如何？';

  @override
  String get qBodyComfort => '练习瑜伽时，您的身体感觉有多舒适？';

  @override
  String get qFlexibility => '您如何评价近期身体的柔韧性？';

  @override
  String get qBalance => '站立或平衡时，您感觉有多稳固？';

  @override
  String get qEnergy => '您整体的能量水平如何？';

  @override
  String get qMood => '您最近的心情如何？';

  @override
  String get qConfidence => '在日常活动中，您感觉有多自信？';

  @override
  String get qBodyConnection => '练习瑜伽时，您感觉与身体的连接度如何？';

  @override
  String get qOverall => '总的来说，您的身心状态如何？';

  @override
  String get notesOptional => '备注（可选）';

  @override
  String get cancel => '取消';

  @override
  String get submit => '提交';

  @override
  String get notes => '备注: ';

  @override
  String get rateAllError => '请对所有项目进行评分';

  @override
  String get checkInSaved => '身心打卡已保存！';

  @override
  String get reflectionHistory => '打卡历史记录';

  @override
  String get noReflections => '暂无打卡记录';

  @override
  String get platinum => '铂金';

  @override
  String get gold => '黄金';

  @override
  String get silver => '白银';

  @override
  String get bronze => '青铜';

  @override
  String get none => '暂无';

  @override
  String get section1Title => '第一部分：身体舒适度与活动能力';

  @override
  String get section2Title => '第二部分：能量与情绪';

  @override
  String get section3Title => '第三部分：自我意识与自信';

  @override
  String get section4Title => '⭐ 整体健康状态';

  @override
  String get qBodyComfortFull => '1️⃣ 运动时您的身体感觉有多舒适？';

  @override
  String get optComfort1 => '不舒服';

  @override
  String get optComfort2 => '轻微舒服';

  @override
  String get optComfort3 => '中度舒服';

  @override
  String get optComfort4 => '非常舒服';

  @override
  String get optComfort5 => '极其舒服';

  @override
  String get qFlexibilityFull => '2️⃣ 您如何描述近期的身体柔韧性？';

  @override
  String get optFlexibility1 => '僵硬很多';

  @override
  String get optFlexibility2 => '有一点僵硬';

  @override
  String get optFlexibility3 => '基本没变';

  @override
  String get optFlexibility4 => '更柔韧了一点';

  @override
  String get optFlexibility5 => '柔韧很多';

  @override
  String get qBalanceFull => '3️⃣ 站立或平衡时，您感觉有多稳固？';

  @override
  String get optBalance1 => '一点也不稳';

  @override
  String get optBalance2 => '轻微稳固';

  @override
  String get optBalance3 => '中度稳固';

  @override
  String get optBalance4 => '非常稳固';

  @override
  String get optBalance5 => '极其稳固';

  @override
  String get qEnergyFull => '4️⃣ 您整体的能量水平如何？';

  @override
  String get optEnergy1 => '极低';

  @override
  String get optEnergy2 => '低';

  @override
  String get optEnergy3 => '一般';

  @override
  String get optEnergy4 => '好';

  @override
  String get optEnergy5 => '非常好';

  @override
  String get qMoodFull => '5️⃣ 您最近的心情如何？';

  @override
  String get optMood1 => '经常感到压力或沮丧';

  @override
  String get optMood2 => '有时有压力';

  @override
  String get optMood3 => '基本还可以';

  @override
  String get optMood4 => '大多很积极';

  @override
  String get optMood5 => '非常积极且平静';

  @override
  String get qConfidenceFull => '6️⃣ 在日常活动中，您感觉有多自信？';

  @override
  String get optConfidence1 => '不自信';

  @override
  String get optConfidence2 => '轻微自信';

  @override
  String get optConfidence3 => '有点自信';

  @override
  String get optConfidence4 => '自信';

  @override
  String get optConfidence5 => '非常自信';

  @override
  String get qBodyConnectionFull => '7️⃣ 练习瑜伽时，您感觉与身体的连接度如何？';

  @override
  String get optConnection1 => '无连接感';

  @override
  String get optConnection2 => '有一点连接感';

  @override
  String get optConnection3 => '中度连接感';

  @override
  String get optConnection4 => '非常有连接感';

  @override
  String get optConnection5 => '深度连接感';

  @override
  String get qOverallFull => '8️⃣ 总的来说，您如何评价本月的健康状态？';

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
  String get monthlyReflections => '💭 每月反思 (可选)';

  @override
  String get shareImprovements => '分享您注意到的具体进步：';

  @override
  String get labelBalance => '🧘 平衡能力提升';

  @override
  String get hintBalance => '例如：我可以单脚站立更久了...';

  @override
  String get labelPosture => '🪑 体态改善';

  @override
  String get hintPosture => '例如：我的背部感觉更挺直了...';

  @override
  String get labelConsistency => '📅 练习习惯与坚持';

  @override
  String get hintConsistency => '例如：我现在每天早上都会练习...';

  @override
  String get labelOther => '💬 其他想法';

  @override
  String get hintOther => '任何其他的进步或备注...';

  @override
  String get skipForNow => '暂时跳过';

  @override
  String get submitCheckIn => '提交打卡';

  @override
  String get validationErrorCheckIn => '请在提交前回答所有必填问题';

  @override
  String get bodyComfort => '身体舒适度';

  @override
  String get flexibility => '柔韧性';

  @override
  String get balance => '平衡能力';

  @override
  String get energy => '精力水平';

  @override
  String get mood => '情绪状态';

  @override
  String get confidence => '自信度';

  @override
  String get mindBody => '身心连接';

  @override
  String get wellbeing => '整体健康';

  @override
  String get nowPlaying => '正在播放';

  @override
  String get moreDetails => '更多详情';

  @override
  String get aboutThisSound => '关于此音效';

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
  String get soundBenefit2 => '• 提高专注力和注意力';

  @override
  String get soundBenefit3 => '• 促进深度睡眠';

  @override
  String get soundBenefit4 => '• 增强整体身心健康';

  @override
  String get welcomeBackSounds => '欢迎回来，';

  @override
  String get findYourPeace => '寻找内心的宁静';

  @override
  String get tabAll => '全部';

  @override
  String get tabRecent => '最近播放';

  @override
  String get tabSaved => '已保存';

  @override
  String get tabFavorites => '收藏';

  @override
  String get mostPopular => '热门推荐';

  @override
  String get latest => '最新上架';

  @override
  String get noRecentSounds => '暂无播放记录';

  @override
  String get noSavedSounds => '暂无保存的音效';

  @override
  String get noFavoriteSounds => '暂无收藏的音效';

  @override
  String get savedSuccess => '已保存！';

  @override
  String get removedFromSaved => '已取消保存';

  @override
  String get audioLoadError => '音频加载失败，请尝试其他音效。';

  @override
  String get soundOceanWaves => '海浪声';

  @override
  String get soundForestRain => '森林雨声';

  @override
  String get soundTibetanBowls => '西藏颂钵';

  @override
  String get soundPeacefulPiano => '宁静钢琴';

  @override
  String get soundMountainStream => '山间小溪';

  @override
  String get soundWindChimes => '风铃声';

  @override
  String get soundGentleThunder => '柔和雷鸣';

  @override
  String get soundSingingBirds => '鸟语鸣啭';

  @override
  String get categoryNature => '自然';

  @override
  String get categoryMeditation => '冥想';

  @override
  String get categoryAmbient => '氛围';

  @override
  String get profileTitle => '个人主页';

  @override
  String get edit => '编辑';

  @override
  String get sessions => '练习次数';

  @override
  String get minutesLabel => '练习分钟';

  @override
  String get daily => '每日连胜 🔥';

  @override
  String get streakSummary => '统计概览';

  @override
  String get weeklyActive => '每周活跃周数';

  @override
  String get preferences => '偏好设置';

  @override
  String get enabled => '已开启';

  @override
  String get disabled => '已关闭';

  @override
  String get logout => '退出登录';

  @override
  String get editProfile => '编辑个人资料';

  @override
  String get save => '保存';

  @override
  String get uploadPhoto => '上传照片';

  @override
  String get removePhoto => '删除照片';

  @override
  String get photoUpdated => '个人资料图片已更新';

  @override
  String get photoRemoved => '个人资料图片已删除';

  @override
  String get photoFail => '上传失败';

  @override
  String get basicInfo => '基本信息';

  @override
  String get fullName => '姓名';

  @override
  String get age => '年龄';

  @override
  String get experienceLevel => '经验水平';

  @override
  String get sessionLength => '练习时长';

  @override
  String get language => '语言';

  @override
  String get notifications => '通知';

  @override
  String get pushNotifications => '推送通知';

  @override
  String get pushEnabledMsg => '推送通知已开启！🔔';

  @override
  String get dailyReminder => '每日练习提醒';

  @override
  String get dailyReminderEnabled => '每日提醒已开启！';

  @override
  String get dailyEnabledMsg => '我们将每天提醒您进行练习。🌞';

  @override
  String get reminderTime => '提醒时间';

  @override
  String get dailyReminderNotification => '每日练习提醒';

  @override
  String get dailyReminderBody => '该进行每日练习了！🏃‍♀️';

  @override
  String get sound => '声音';

  @override
  String get soundEffects => '音效';

  @override
  String get appVolume => '应用音量';

  @override
  String get systemVolume => '系统音量';

  @override
  String get appVolumeDesc => '调节此应用内的声音音量';

  @override
  String get systemVolumeDesc => '调节设备的系统音量';

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
  String get mandarin => '中文';

  @override
  String get sessionComplete => '课程完成！';

  @override
  String completedPosesCount(int count) {
    return '您完成了 $count 个体式！';
  }

  @override
  String get minutes => '分钟';

  @override
  String get totalTime => '总时间';

  @override
  String get next => '下一个';

  @override
  String get aboutThisPose => '关于此体式';

  @override
  String get exitSession => '退出课程？';

  @override
  String get exitSessionMessage => '如果现在退出，您的进度将不会保存。确定要退出吗？';

  @override
  String get exit => '退出';
}
