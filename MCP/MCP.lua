--
-- MCP - Master Control Program
--
-- Allows you to control AddOn loading after logging in.
--
--  Marc aka Saien on Hyjal
--  WOWSaien@gmail.com
--  http://64.168.251.69/wow
--
-- Changes
--   2016.11.27 (by zerosnake0)
--     The Blizzard addons must be enabled/disabled explicitely by user
--     They will not be affected by the enable/disable all button
--   2016.02.09 (by zerosnake0)
--     Deleted variable "refusetoload", which does nothing
--     Added line breaking in the tooltip, support also utf8
--   2016.02.08 (by zerosnake0)
--     Added Chinese translation and fix localization problems
--     Added profile overwrite confirmation
--   2006.09.09
--     2.2-BD release
--     Made sure MCP doesn't turn itself off when checking disable all addons
--   2006.09.06
--     2.1-BD release
--     Added localization
--     Added enable/disable all buttons
--     Added tooltip when you mouse over an addon to show the notes
--   2006.09.02
--     2.0-BD release
--     modifications by Bluedragon, alliance Frostwolf server
--     Added slash command /mcp to open the window
--     Added profiles for quickly changing which addons are enabled/disabled
--   2006.01.02
--     1.9 release
--     In game changes to the addon list are limited to changing the currently
--       logged in character only. You cannot change Addons for other characters.
--       This is a Blizzard restriction.
--   2005.10.10
--     1.8 release

UIPanelWindows["MCP_AddonList"] = { area = "center", pushable = 0, whileDead = 1 };
StaticPopupDialogs["MCP_RELOADUI"] = {
  text = MCP_RELOAD,
  button1 = TEXT(ACCEPT),
  button2 = TEXT(CANCEL),
  OnAccept = function() ReloadUI(); end,
  timeout = 0,
  hideOnEscape = 1
};

local MCP_DBG = true
local function MCP_Debug(msg)
  DEFAULT_CHAT_FRAME:AddMessage("[MCP_DBG] "..msg)
end

function MCP_SelectProfile(profile)
  if profile and MCP_Config.profiles[profile] then
    MCP_Config.SelectedProfile = profile;
  else
    MCP_Config.SelectedProfile = MCP_PROFILE_NON;
  end
  UIDropDownMenu_SetText(MCP_Config.SelectedProfile, MCP_AddonList_ProfileSelection);
end

function MCP_DeleteDialog()
  local profile = MCP_Config.SelectedProfile

  -- check if the chosen profile is invalid
  if profile == MCP_PROFILE_NON or not MCP_Config.profiles[profile] then
    StaticPopupDialogs["MCP_DELETEPROFILE"] = {
      text = MCP_DELETE_PROFILE_INVALID,
      button1 = TEXT(OKAY),
      timeout = 2,
      hideOnEscape = 1,
    };
  else
    StaticPopupDialogs["MCP_DELETEPROFILE"] = {
      text = MCP_DELETE_PROFILE_DIALOG.."|cffffd200"..MCP_Config.SelectedProfile,
      button1 = TEXT(ACCEPT),
      button2 = TEXT(CANCEL),
      timeout = 0,
      hideOnEscape = 1,
      OnAccept = function()
        MCP_DeleteProfile(MCP_Config.SelectedProfile);
        MCP_SelectProfile();
      end,
    };
  end
  StaticPopup_Show("MCP_DELETEPROFILE");
end

function MCP_SaveDialog()
  StaticPopupDialogs["MCP_SAVEPROFILE"] = {
    text = MCP_PROFILE_NAME_SAVE;
    button1 = TEXT(ACCEPT),
    button2 = TEXT(CANCEL),
    hasEditBox = 1,
    maxLetters = 32,
    timeout = 0,
    hideOnEscape = 1,
    OnShow = function()
      local text = (MCP_Config.SelectedProfile ~= MCP_PROFILE_NON) and MCP_Config.SelectedProfile or ""
      getglobal(this:GetName().."EditBox"):SetText(text);
    end,
    OnAccept = function()
      local profile = getglobal(this:GetParent():GetName().."EditBox"):GetText();
      -- overwrite check
      if MCP_Config.profiles[profile] then
        StaticPopupDialogs["MCP_SAVEPROFILE_CONFIRM"] = {
          text = string.format(MCP_SAVE_PROFILE_CONFIRM, "|cffffd200"..profile.."|r"),
          button1 = TEXT(ACCEPT),
          button2 = TEXT(CANCEL),
          timeout = 0,
          hideOnEscape = 1,
          OnAccept = function()
            MCP_SaveProfile(profile);
          end,
          OnCancel = function()
            StaticPopup_Show("MCP_SAVEPROFILE");
          end,
        }
        StaticPopup_Show("MCP_SAVEPROFILE_CONFIRM");
      else
        MCP_SaveProfile(profile);
      end
    end,
    EditBoxOnEnterPressed = function()
      StaticPopupDialogs["MCP_SAVEPROFILE"].OnAccept();
      this:GetParent():Hide();
    end,
  };
  StaticPopup_Show("MCP_SAVEPROFILE");
end

MCP_VERSION = "2016.11.27";
MCP_LINEHEIGHT = 16;
local MCP_MAXADDONS = 20;
local MCP_BLIZZARD_ADDONS = {
  "Blizzard_AuctionUI",
  "Blizzard_BattlefieldMinimap",
  "Blizzard_BindingUI",
  "Blizzard_CombatText",
  "Blizzard_CraftUI",
  "Blizzard_GMSurveyUI",
  "Blizzard_InspectUI",
  "Blizzard_MacroUI",
  "Blizzard_RaidUI",
  "Blizzard_TalentUI",
  "Blizzard_TradeSkillUI",
  "Blizzard_TrainerUI",
};

function MCP_OnLoad()
  if not MCP_Config then MCP_Config = {} end
  if not MCP_Config.profiles then MCP_Config.profiles = {} end

  -- setup /mcp slash command
  SlashCmdList["MCPSLASHCMD"] = MCP_SlashHandler;
  SLASH_MCPSLASHCMD1 = "/mcp";

  DEFAULT_CHAT_FRAME:AddMessage(string.format(MCP_WELCOME_MSG, SLASH_MCPSLASHCMD1))
end

function MCP_SlashHandler(msg)
  if msg == "debug" or msg == "dbg" then
    MCP_DBG = not MCP_DBG;
  else
    ShowUIPanel(MCP_AddonList);
  end
end

function MCP_AddonList_Enable(index,enabled)
  if (enabled) then
    EnableAddOn(index)
  else
    DisableAddOn(index)
  end
  MCP_AddonList_OnShow();
end

function MCP_AddonList_LoadNow(index)
  UIParentLoadAddOn(index);
  MCP_AddonList_OnShow();
end

function MCP_AddonList_OnShow()
  local function setSecurity (obj, idx)
    local width,height,iconWidth = 64,16,16;
    local increment = iconWidth/width;
    local left = (idx-1)*increment;
    local right = idx*increment;
    obj:SetTexCoord(left, right, 0, 1);
  end

  local origNumAddons = GetNumAddOns();
  local numAddons = origNumAddons + table.getn(MCP_BLIZZARD_ADDONS);

  FauxScrollFrame_Update(MCP_AddonList_ScrollFrame, numAddons, MCP_MAXADDONS, MCP_LINEHEIGHT, nil, nil, nil);

  local i;
  local offset = FauxScrollFrame_GetOffset(MCP_AddonList_ScrollFrame);

  for i = 1, MCP_MAXADDONS do
    obj = getglobal("MCP_AddonListEntry"..i);
    local addonIdx = offset+i;
    if (addonIdx > numAddons) then
      obj:Hide();
      obj.addon = nil;
    else
      obj:Show();
      local titleText = getglobal("MCP_AddonListEntry"..i.."Title");
      local status = getglobal("MCP_AddonListEntry"..i.."Status");
      local checkbox = getglobal("MCP_AddonListEntry"..i.."Enabled");
      local securityIcon = getglobal("MCP_AddonListEntry"..i.."SecurityIcon");
      local loadnow = getglobal("MCP_AddonListEntry"..i.."LoadNow");

      local name, title, notes, enabled, loadable, reason, security;
      if (addonIdx > origNumAddons) then
        name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(MCP_BLIZZARD_ADDONS[(addonIdx-origNumAddons)]);
        obj.addon = name
      else
        name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(addonIdx);
        obj.addon = addonIdx;
      end

      local loaded = IsAddOnLoaded(name);
      local ondemand = IsAddOnLoadOnDemand(name);

      if (loadable) then
        titleText:SetTextColor(1,0.78,0);
      elseif (enabled and reason ~= "DEP_DISABLED") then
        titleText:SetTextColor(1,0.1,0.1);
      else
        titleText:SetTextColor(0.5,0.5,0.5);
      end

      if (title) then
        titleText:SetText(title);
      else
        titleText:SetText(name);
      end

      if (title == MCP_TITLE_TOC) then
        checkbox:Hide();
      else
        checkbox:Show();
        checkbox:SetChecked(enabled);
      end

      if (security == "SECURE") then
        setSecurity(securityIcon,1);
      elseif (security == "INSECURE") then
        setSecurity(securityIcon,2);
      elseif (security == "BANNED") then
        setSecurity(securityIcon,3);
      end

      if (reason) then
        status:SetText(TEXT(getglobal("ADDON_"..reason)));
      elseif (loaded) then
        status:SetText(TEXT(MCP_ADDON_LOADED));
      elseif (ondemand) then
        status:SetText(TEXT(MCP_LOADED_ON_DEMAND));
      else
        status:SetText("");
      end

      if (not loaded and enabled and ondemand) then
        loadnow:Show();
      else
        loadnow:Hide();
      end
    end

  end
end

function MCP_SaveProfile(profile)
  if profile == MCP_PROFILE_NON then return end

  local numAddons = GetNumAddOns();
  local i;

  -- setup this profile, and clear any previous data in case it exists
  MCP_Config.profiles[profile] = {};

  -- set each addon to be loaded or not loaded
  for i = 1, numAddons do
    local name, _, _, enabled = GetAddOnInfo(i);
    MCP_Config.profiles[profile][name] = (name == "MCP" or enabled) and true or false;
  end

  for k, v in MCP_BLIZZARD_ADDONS do
    local name, _, _, enabled = GetAddOnInfo(v);
    MCP_Config.profiles[profile][name] = enabled and true or false;
  end

  StaticPopupDialogs["MCP_PROFILESAVED"] = {
    text=MCP_PROFILE_SAVED.."|cffffd200"..profile,
    button1 = TEXT(OKAY),
    timeout = 2,
    hideOnEscape = 1
  };
  StaticPopup_Show("MCP_PROFILESAVED");

  MCP_SelectProfile(profile, MCP_AddonList_ProfileSelection);
end

function MCP_LoadProfile()

  local i;
  local addons;

  if not this.value then
    MCP_SelectProfile(MCP_PROFILE_NON);
    return;
  end

  MCP_Config.SelectedProfile = this.value

  for addons in MCP_Config.profiles[MCP_Config.SelectedProfile] do
    if addons == "MCP" or MCP_Config.profiles[MCP_Config.SelectedProfile][addons] then
      EnableAddOn(addons);
    else
      DisableAddOn(addons);
    end
  end

  MCP_SelectProfile(MCP_Config.SelectedProfile, MCP_AddonList_ProfileSelection);

  MCP_AddonList_OnShow()
end

function MCP_DeleteProfile(profile)
  local buttontext;

  if profile == MCP_PROFILE_NON then
    buttontext = MCP_NO_PROFILE_DELETED;
  else
    buttontext = MCP_PROFILE_DELETED.."|cffffd200"..profile;
    MCP_Config.profiles[profile] = nil;
  end

  StaticPopupDialogs["MCP_PROFILEDELETED"] = {
    text=buttontext,
    button1 = TEXT(OKAY),
    timeout = 2,
    hideOnEscape = 1
  };
  StaticPopup_Show("MCP_PROFILEDELETED");
end

function MCP_ResetProfiles(param)
  UIDropDownMenu_Initialize(this,  MCP_InitializeProfiles);
  UIDropDownMenu_SetWidth(180, this);
  MCP_SelectProfile(MCP_Config.SelectedProfile)
end

function MCP_InitializeProfiles()
  if not MCP_Config then MCP_Config = {} end
  if not MCP_Config.profiles then MCP_Config.profiles = {} end
  
  local info = {};
  local profile;
  for profile in MCP_Config.profiles do
    info = {
      ["text"] = profile,
      ["value"] = profile,
      ["func"] = MCP_LoadProfile,
    };
    UIDropDownMenu_AddButton(info);
  end
end

function MCP_EnableAll()
  local numAddons = GetNumAddOns();
  local i;

  -- set each addon to be enabled
  for i = 1, numAddons do
    local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i);
    if not enabled then
      EnableAddOn(name);
    end
  end 

  MCP_AddonList_OnShow()
end

function MCP_DisableAll()
  local numAddons = GetNumAddOns();
  local i;

  -- set each addon to be enabled
  for i = 1, numAddons do
    local name, _, _, enabled = GetAddOnInfo(i);
    if enabled and name ~= "MCP" then
      DisableAddOn(name);
    end
  end
  
  MCP_AddonList_OnShow()
end

-- source: http://wowprogramming.com/snippets/UTF-8_aware_stringsub_7
-- UTF-8 Reference:
-- 0xxxxxxx - 1 byte UTF-8 codepoint (ASCII character)
-- 110yyyxx - First byte of a 2 byte UTF-8 codepoint
-- 1110yyyy - First byte of a 3 byte UTF-8 codepoint
-- 11110zzz - First byte of a 4 byte UTF-8 codepoint
-- 10xxxxxx - Inner byte of a multi-byte UTF-8 codepoint
local function chsize(char)
    if not char then
        return 0
    elseif char >= 240 then
        return 4
    elseif char >= 224 then
        return 3
    elseif char >= 192 then
        return 2
    else
        return 1
    end
end

function MCP_TooltipShow(index)
  local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(index);
  local maxLettersPerLine = 50
  local maxLines = 20
  
  GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
  if title then
    GameTooltip:AddLine(title);
  else
    GameTooltip:AddLine(name);
  end

  if notes then
    local i,l = 1,string.len(notes);
    local line,nchar,nline = "",0,0;
    local c,s;
    while i <= l do
      c = string.sub(notes,i,i)
      s = chsize(string.byte(c))
      if (s > 1 or c == ' ') and nchar >= maxLettersPerLine then
        GameTooltip:AddLine(line);
        nline = nline + 1
        line = ""
        nchar = 0
        if nline == maxLines and i <= l then
          GameTooltip:AddLine("...")
          break
        end
      end
      line = line .. string.sub(notes,i,i+s-1)
      nchar = nchar + s
      i = i + s
    end
    if i > l then
      GameTooltip:AddLine(line);
    end
  else
    GameTooltip:AddLine(MCP_NO_NOTES);
  end
  GameTooltip:Show();
end
