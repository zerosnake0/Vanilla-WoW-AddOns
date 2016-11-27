local locale = GetLocale()

-- English localization

if locale == "enUS" or locale == "enGB" then

	MCP_TITLE_TOC = "Master Control Program"
	MCP_WELCOME_MSG = "MCP(modified by zerosnake0) loaded, type %s to open the window"
	MCP_PROFILE_NON = "No profile chosen"
	MCP_SAVE_PROFILE_CONFIRM = "The profile %s already exists, overwrite?"
	
	MCP_ADDON_LOADED = "Loaded";
	MCP_ADDON_REFUSE_TO_LOAD = "Disabled in MCP";
	MCP_LOADED_ON_DEMAND = "Loaded on demand";
	
	MCP_RELOAD = "Reload your user interface?";
	MCP_DELETE_PROFILE_INVALID = "Please choose a profile to delete."
	MCP_DELETE_PROFILE_DIALOG = "Delete profile: ";
	MCP_PROFILE_NAME_SAVE = "Profile name";
	
	MCP_PROFILE_SAVED = "Profile saved: ";
	MCP_PROFILE_DELETED = "Profile deleted: ";
	MCP_NO_PROFILE_DELETED = "No profile deleted.";
	
	MCP_LOAD = "Load";
	MCP_ADDONS = "AddOns";
	MCP_RELOADUI = "ReloadUI";
	MCP_SAVE_PROFILE = "Save Profile";
	MCP_DELETE_PROFILE = "Delete Profile";
	MCP_ENABLE_ALL = "Enable All";
	MCP_DISABLE_ALL = "Disable All";
	
	MCP_NO_NOTES = "No information available.";

-- Korean Translation by Mars

elseif (GetLocale() == "koKR") then

  MCP_ADDON_LOADED = "실행됨";
  MCP_ADDON_REFUSE_TO_LOAD = "MCP에서 비활성화됨";
  MCP_LOADED_ON_DEMAND = "사용시 자동 실행";

  MCP_RELOAD = "외부인터페이스를 재실행(Reload)하시겠습니까?";
  MCP_DELETE_PROFILE_DIALOG = "프로파일 삭제: ";
  MCP_PROFILE_NAME_SAVE = "프로파일로 저장할 이름을 입력하세요.";

  MCP_PROFILE_SAVED = "저장된 프로파일: ";
  MCP_PROFILE_DELETED = "삭제된 프로파일: ";
  MCP_NO_PROFILE_DELETED = "삭제된 프로파일이 없습니다.";

  MCP_LOAD = "실행";
  MCP_ADDONS = "애드온 설정";
  MCP_RELOADUI = "UI 재실행";
  MCP_SAVE_PROFILE = "프로파일 저장";
  MCP_DELETE_PROFILE = "프로파일 삭제";
  MCP_ENABLE_ALL = "모두 사용";
  MCP_DISABLE_ALL = "모두 미사용";

  MCP_NO_NOTES = "알려진 정보가 없습니다.";

--- Chinese Trnaslation by zerosnake0

elseif (GetLocale() == "zhCN") then

  MCP_TITLE_TOC = "MCP插件管理器"
  MCP_WELCOME_MSG = "MCP插件管理器(zerosnake0汉化修改版)已加载, 输入%s来打开插件面板"
  MCP_PROFILE_NON = "未选择配置文件"
  MCP_SAVE_PROFILE_CONFIRM = "配置文件%s已经存在，要覆盖吗？"

  MCP_ADDON_LOADED = "已载入";
  MCP_ADDON_REFUSE_TO_LOAD = "在MCP中被禁用";
  MCP_LOADED_ON_DEMAND = "按需加载";

  MCP_RELOAD = "重新加载你的界面？";
  MCP_DELETE_PROFILE_INVALID = "请选择一个需要删除的配置"
  MCP_DELETE_PROFILE_DIALOG = "删除配置：";
  MCP_PROFILE_NAME_SAVE = "配置名称";

  MCP_PROFILE_SAVED = "配置已保存：";
  MCP_PROFILE_DELETED = "配置已删除：";
  MCP_NO_PROFILE_DELETED = "没有配置被删除。";

  MCP_LOAD = "加载";
  MCP_ADDONS = "插件";
  MCP_RELOADUI = "重新加载界面";
  MCP_SAVE_PROFILE = "保存配置";
  MCP_DELETE_PROFILE = "删除配置";
  MCP_ENABLE_ALL = "全部启用";
  MCP_DISABLE_ALL = "全部禁用";

  MCP_NO_NOTES = "无可用信息";

end
