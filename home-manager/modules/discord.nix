{pkgs, ...}: {
  xdg.desktopEntries.vesktop = {
    name = "Discord";
    categories = ["Network" "Chat"];
    terminal = false;
    icon = pkgs.fetchurl {
      url = "https://img.icons8.com/?size=100&id=30998&format=png&color=000000";
      sha256 = "sha256-zb3Es1izZAwProek4Wcc7g3ZKxoVzX4JMEqpYIjmLwY=";
    };
    exec = "${pkgs.vesktop}/bin/vesktop --enable-blink-features=MiddleClickAutoscroll --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true";
  };
  programs.vesktop = {
    enable = true;

    settings = {
      discordBranch = "stable";
      minimizeToTray = true;
      arRPC = true;
      splashColor = "rgb(211, 207, 207)";
      splashBackground = "rgb(13, 12, 12)";
      spellCheckLanguages = [
        "en-US"
        "en"
      ];
      enableSplashScreen = false;
      splashTheming = true;
      tray = true;
      hardwareVideoAcceleration = true;
      customTitleBar = false;
      clickTrayToShowHide = true;
      enableMenu = false;
    };
    vencord = {
      settings = {
        autoUpdate = false;
        autoUpdateNotification = true;
        useQuickCss = false;
        themeLinks = [];
        eagerPatches = false;
        enabledThemes = [];
        enableReactDevtools = false;
        frameless = false;
        transparent = true;
        winCtrlQ = false;
        disableMinSize = false;
        winNativeTitleBar = false;
        plugins = {
          ChatInputButtonAPI = {
            enabled = true;
          };
          CommandsAPI = {
            enabled = true;
          };
          DynamicImageModalAPI = {
            enabled = false;
          };
          MemberListDecoratorsAPI = {
            enabled = true;
          };
          MessageAccessoriesAPI = {
            enabled = true;
          };
          MessageDecorationsAPI = {
            enabled = true;
          };
          MessageEventsAPI = {
            enabled = true;
          };
          MessagePopoverAPI = {
            enabled = true;
          };
          MessageUpdaterAPI = {
            enabled = true;
          };
          ServerListAPI = {
            enabled = false;
          };
          UserSettingsAPI = {
            enabled = true;
          };
          AccountPanelServerProfile = {
            enabled = true;
          };
          AlwaysAnimate = {
            enabled = true;
          };
          AlwaysExpandRoles = {
            enabled = true;
          };
          AlwaysTrust = {
            enabled = false;
          };
          AnonymiseFileNames = {
            enabled = false;
            anonymiseByDefault = true;
            method = 0;
            randomisedLength = 7;
            consistent = "image";
          };
          "WebRichPresence (arRPC)" = {
            enabled = false;
          };
          BetterFolders = {
            enabled = true;
            sidebar = true;
            showFolderIcon = 1;
            keepIcons = false;
            closeAllHomeButton = false;
            closeAllFolders = false;
            forceOpen = false;
            sidebarAnim = true;
            closeOthers = false;
          };
          BetterGifAltText = {
            enabled = true;
          };
          BetterGifPicker = {
            enabled = true;
          };
          BetterNotesBox = {
            enabled = true;
            hide = false;
          };
          BetterRoleContext = {
            enabled = true;
          };
          BetterRoleDot = {
            enabled = true;
            bothStyles = false;
            copyRoleColorInProfilePopout = false;
          };
          BetterSessions = {
            enabled = true;
            backgroundCheck = false;
          };
          BetterSettings = {
            enabled = true;
            disableFade = true;
            eagerLoad = true;
            organizeMenu = true;
          };
          BetterUploadButton = {
            enabled = true;
          };
          BiggerStreamPreview = {
            enabled = true;
          };
          BlurNSFW = {
            enabled = true;
            blurAmount = 10;
          };
          CallTimer = {
            enabled = false;
            format = "stopwatch";
          };
          ClearURLs = {
            enabled = true;
          };
          ClientTheme = {
            enabled = true;
            color = "181616";
          };
          ColorSighted = {
            enabled = true;
          };
          ConsoleJanitor = {
            enabled = false;
          };
          ConsoleShortcuts = {
            enabled = false;
          };
          CopyEmojiMarkdown = {
            enabled = false;
            copyUnicode = true;
          };
          CopyFileContents = {
            enabled = false;
          };
          CopyStickerLinks = {
            enabled = false;
          };
          CopyUserURLs = {
            enabled = false;
          };
          CrashHandler = {
            enabled = true;
          };
          CtrlEnterSend = {
            enabled = false;
          };
          CustomIdle = {
            enabled = false;
          };
          CustomRPC = {
            enabled = false;
          };
          Dearrow = {
            enabled = true;
            hideButton = false;
            replaceElements = 0;
            dearrowByDefault = true;
          };
          Decor = {
            enabled = false;
          };
          DisableCallIdle = {
            enabled = false;
          };
          DontRoundMyTimestamps = {
            enabled = false;
          };
          Experiments = {
            enabled = false;
            toolbarDevMenu = false;
          };
          ExpressionCloner = {
            enabled = false;
          };
          F8Break = {
            enabled = false;
          };
          FakeNitro = {
            enabled = true;
          };
          FakeProfileThemes = {
            enabled = false;
          };
          FavoriteEmojiFirst = {
            enabled = false;
          };
          FavoriteGifSearch = {
            enabled = false;
          };
          FixCodeblockGap = {
            enabled = true;
          };
          FixImagesQuality = {
            enabled = true;
          };
          ForceOwnerCrown = {
            enabled = false;
          };
          FriendInvites = {
            enabled = false;
          };
          FriendsSince = {
            enabled = false;
          };
          FullSearchContext = {
            enabled = false;
          };
          FullUserInChatbox = {
            enabled = false;
          };
          GameActivityToggle = {
            enabled = false;
          };
          GifPaste = {
            enabled = false;
          };
          GreetStickerPicker = {
            enabled = false;
          };
          HideMedia = {
            enabled = false;
          };
          iLoveSpam = {
            enabled = false;
          };
          IgnoreActivities = {
            enabled = false;
          };
          ImageFilename = {
            enabled = true;
            showFullUrl = false;
          };
          ImageLink = {
            enabled = false;
          };
          ImageZoom = {
            enabled = false;
          };
          ImplicitRelationships = {
            enabled = false;
          };
          IrcColors = {
            enabled = true;
            memberListColors = true;
            lightness = 70;
            applyColorOnlyInDms = false;
            applyColorOnlyToUsersWithoutColor = false;
          };
          KeepCurrentChannel = {
            enabled = false;
          };
          LastFMRichPresence = {
            enabled = false;
          };
          LoadingQuotes = {
            enabled = false;
          };
          MemberCount = {
            enabled = false;
          };
          MentionAvatars = {
            enabled = false;
          };
          MessageClickActions = {
            enabled = false;
          };
          MessageLatency = {
            enabled = true;
            latency = 2;
            detectDiscordKotlin = true;
            showMillis = false;
            ignoreSelf = false;
          };
          MessageLinkEmbeds = {
            enabled = true;
          };
          MessageLogger = {
            enabled = false;
          };
          MessageTags = {
            enabled = false;
          };
          MutualGroupDMs = {
            enabled = true;
          };
          NewGuildSettings = {
            enabled = true;
            guild = true;
            messages = 3;
            everyone = true;
            role = true;
            highlights = true;
            events = true;
            showAllChannels = true;
          };
          NoBlockedMessages = {
            enabled = false;
          };
          NoDevtoolsWarning = {
            enabled = false;
          };
          NoF1 = {
            enabled = true;
          };
          NoMaskedUrlPaste = {
            enabled = false;
          };
          NoMosaic = {
            enabled = false;
            inlineVideo = true;
          };
          NoOnboardingDelay = {
            enabled = false;
          };
          NoPendingCount = {
            enabled = false;
          };
          NoProfileThemes = {
            enabled = true;
          };
          NoReplyMention = {
            enabled = false;
          };
          NoServerEmojis = {
            enabled = false;
          };
          NoTypingAnimation = {
            enabled = false;
          };
          NoUnblockToJump = {
            enabled = false;
          };
          NormalizeMessageLinks = {
            enabled = false;
          };
          NotificationVolume = {
            enabled = false;
          };
          OnePingPerDM = {
            enabled = false;
          };
          oneko = {
            enabled = false;
          };
          OpenInApp = {
            enabled = false;
          };
          OverrideForumDefaults = {
            enabled = false;
          };
          PauseInvitesForever = {
            enabled = false;
          };
          PermissionFreeWill = {
            enabled = false;
          };
          PermissionsViewer = {
            enabled = false;
          };
          petpet = {
            enabled = false;
          };
          PictureInPicture = {
            enabled = false;
          };
          PinDMs = {
            enabled = false;
          };
          PlainFolderIcon = {
            enabled = false;
          };
          PlatformIndicators = {
            enabled = true;
            list = true;
            badges = true;
            messages = true;
            colorMobileIndicator = true;
          };
          PreviewMessage = {
            enabled = false;
          };
          QuickMention = {
            enabled = true;
          };
          QuickReply = {
            enabled = true;
            shouldMention = 2;
            ignoreBlockedAndIgnored = true;
          };
          ReactErrorDecoder = {
            enabled = false;
          };
          ReadAllNotificationsButton = {
            enabled = false;
          };
          RelationshipNotifier = {
            enabled = false;
          };
          ReplaceGoogleSearch = {
            enabled = false;
          };
          ReplyTimestamp = {
            enabled = false;
          };
          RevealAllSpoilers = {
            enabled = false;
          };
          ReverseImageSearch = {
            enabled = false;
          };
          ReviewDB = {
            enabled = false;
          };
          RoleColorEverywhere = {
            enabled = false;
          };
          SecretRingToneEnabler = {
            enabled = false;
          };
          Summaries = {
            enabled = false;
          };
          SendTimestamps = {
            enabled = false;
          };
          ServerInfo = {
            enabled = false;
          };
          ServerListIndicators = {
            enabled = false;
          };
          ShowAllMessageButtons = {
            enabled = false;
          };
          ShowConnections = {
            enabled = false;
          };
          ShowHiddenChannels = {
            enabled = false;
          };
          ShowHiddenThings = {
            enabled = false;
          };
          ShowMeYourName = {
            enabled = true;
            mode = "user-nick";
            friendNicknames = "dms";
            displayNames = false;
            inReplies = false;
          };
          ShowTimeoutDuration = {
            enabled = false;
          };
          SilentMessageToggle = {
            enabled = false;
          };
          SilentTyping = {
            enabled = true;
            isEnabled = true;
            showIcon = false;
          };
          SortFriendRequests = {
            enabled = false;
          };
          SpotifyControls = {
            enabled = false;
          };
          SpotifyCrack = {
            enabled = false;
          };
          SpotifyShareCommands = {
            enabled = false;
          };
          StartupTimings = {
            enabled = true;
          };
          StickerPaste = {
            enabled = false;
          };
          StreamerModeOnStream = {
            enabled = false;
          };
          SuperReactionTweaks = {
            enabled = false;
          };
          TextReplace = {
            enabled = false;
          };
          ThemeAttributes = {
            enabled = false;
          };
          Translate = {
            enabled = false;
          };
          TypingIndicator = {
            enabled = true;
            includeMutedChannels = false;
            includeCurrentChannel = true;
          };
          TypingTweaks = {
            enabled = true;
            alternativeFormatting = true;
          };
          Unindent = {
            enabled = false;
          };
          UnlockedAvatarZoom = {
            enabled = false;
          };
          UnsuppressEmbeds = {
            enabled = false;
          };
          UserMessagesPronouns = {
            enabled = false;
          };
          UserVoiceShow = {
            enabled = false;
          };
          USRBG = {
            enabled = false;
          };
          ValidReply = {
            enabled = false;
          };
          ValidUser = {
            enabled = false;
          };
          VoiceChatDoubleClick = {
            enabled = false;
          };
          VcNarrator = {
            enabled = false;
          };
          VencordToolbox = {
            enabled = true;
          };
          ViewIcons = {
            enabled = false;
          };
          ViewRaw = {
            enabled = false;
          };
          VoiceDownload = {
            enabled = false;
          };
          VoiceMessages = {
            enabled = false;
          };
          VolumeBooster = {
            enabled = false;
          };
          WebContextMenus = {
            enabled = true;
            addBack = false;
          };
          WebKeybinds = {
            enabled = true;
          };
          WebScreenShareFixes = {
            enabled = true;
          };
          WhoReacted = {
            enabled = true;
          };
          XSOverlay = {
            enabled = false;
          };
          BadgeAPI = {
            enabled = true;
          };
          NoTrack = {
            enabled = true;
            disableAnalytics = true;
          };
          Settings = {
            enabled = true;
            settingsLocation = "aboveNitro";
          };
          DisableDeepLinks = {
            enabled = true;
          };
          SupportHelper = {
            enabled = true;
          };
          AppleMusicRichPresence = {
            enabled = false;
          };
          FixSpotifyEmbeds = {
            enabled = false;
          };
          FixYoutubeEmbeds = {
            enabled = true;
          };
          InvisibleChat = {
            enabled = false;
          };
          ShikiCodeblocks = {
            enabled = true;
          };
          YoutubeAdblock = {
            enabled = true;
          };
          notifications = {
            timeout = 5000;
            position = "bottom-right";
            useNative = "always";
            logLimit = 50;
          };
          cloud = {
            authenticated = false;
            url = "https://api.vencord.dev/";
            settingsSync = false;
            settingsSyncVersion = 1760251156215;
          };
        };
      };
    };
  };
}
