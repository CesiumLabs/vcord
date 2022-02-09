module valkyria

pub struct Ready {
pub mut:
        v           int
        session_id  string
        shard       []int
        application Application
        user        User
        guilds      []UnavailableGuild
}

pub struct UnavailableGuild {
pub mut:
        id          string
        unavailable bool
}

pub struct Application {
pub mut:
        id                     string
        name                   string
        owner                  User
        icon                   string
        description            string
        rpc_origins            []string
        bot_public             bool
        bot_require_code_grant bool
        terms_of_service_url   string
        privacy_policy_url     string
        summary                string
        verify_key             string
        team                   Team
        guild_id               string
        primary_sku_id         string
        slug                   string
        cover_image            string
        flags                  int
}

pub struct User {
pub mut:
        id            string
        username      string
        discriminator string
        avatar        string
        bot           bool
        system        bool
        mfa_enabled   bool
        banner        string
        accent_color  int
        locale        string
        verified      bool
        email         string
        flags         int
        premium_type  int
        public_flags  int
        premium_since int
}

pub struct Team {
pub mut:
        icon          string
        id            string
        members       []TeamMember
        name          string
        owner_user_id string
}

pub struct TeamMember {
pub mut:
        user             User
        permissions      []string
        team_id          string
        membership_state int
}
