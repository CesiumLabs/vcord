module vcord

import time
import x.json2 as json
import snowflake

pub struct Ready {
pub mut:
        v           int
        session_id  string
        shard       []int
        application Application
        user        User
        guilds      []UnavailableGuild
}

pub struct Raw {
pub mut:
        op byte
        d  string
        s  u32
        t  string
}

pub struct Message {
pub mut:
        id               string
        channel_id       string
        content          string
        guild_id         string
        author           User
        embeds           []MessageEmbed
        timestamp        time.Time
        edited_timestamp time.Time
        pinned           bool
        message_type     int
        webhook_id       string
        tts              bool
        mention_everyone bool
        nonce            int
        flags            int
}

pub struct Channel {
pub mut:
        id                            string
        @type                         ChannelType
        guild_id                      string
        position                      int
        name                          string
        topic                         string
        nsfw                          bool
        last_message_id               string
        bitrate                       int
        user_limit                    int
        rate_limit_per_user           int
        recipients                    []User
        icon                          string
        owner_id                      string
        parent_id                     string
        last_pin_timestamp            time.Time
        rtc_region                    string
        video_quality_mode            int
        message_count                 int
        default_auto_archive_duration int
        permissions                   string
}

pub enum ChannelType {
        guild_text
        dm
        guild_voice
        group_dm
        guild_category
        guild_news
        guild_store
        guild_news_thread = 10
        guild_public_thread = 11
        guild_private_thread = 12
        guild_stage_voice = 13
}

pub fn (message Message) snowflake() snowflake.Snowflake {
        return snowflake.deconstruct(message.id.u64())
}

pub struct MessageEmbed {
pub mut:
        title       string
        description string
        url         string
        provider    MessageEmbedProvider
        footer      MessageEmbedFooter
        fields      []MessageEmbedField
        author      MessageEmbedAuthor
        embed_type  string
        timestamp   time.Time
        color       int
        image       MessageEmbedImage
        thumbnail   MessageEmbedThumbnail
        video       MessageEmbedVideo
}

pub fn (embed MessageEmbed) to_json() json.Any {
        mut data := map[string]json.Any{}
        data['title'] = embed.title
        data['description'] = embed.description
        data['color'] = embed.color
        data['footer'] = embed.footer.to_json()
        data['image'] = embed.image.to_json()
        data['thumbnail'] = embed.thumbnail.to_json()
        data['author'] = embed.author.to_json()
        data['fields'] = embed.fields.to_json()
        return data
}

pub fn (embeds []MessageEmbed) to_json() json.Any {
        mut data := []json.Any{}
        for embed in embeds {
                data << embed.to_json()
        }
        return data
}

pub struct MessageEmbedProvider {
pub mut:
        name string
        url  string
}

pub struct MessageEmbedImage {
pub mut:
        url       string
        proxy_url string
        height    int
        width     int
}

pub fn (image MessageEmbedImage) to_json() json.Any {
        mut data := map[string]json.Any{}
        data['url'] = image.url
        data['proxy_url'] = image.proxy_url
        data['height'] = image.height
        data['width'] = image.width

        return data
}

pub struct MessageEmbedThumbnail {
pub mut:
        url       string
        proxy_url string
        height    int
        width     int
}

pub fn (thumbnail MessageEmbedThumbnail) to_json() json.Any {
        mut data := map[string]json.Any{}
        data['url'] = thumbnail.url
        data['proxy_url'] = thumbnail.proxy_url
        data['height'] = thumbnail.height
        data['width'] = thumbnail.width

        return data
}

pub struct MessageEmbedVideo {
pub mut:
        url       string
        proxy_url string
        height    int
        width     int
}

pub struct MessageEmbedAuthor {
pub mut:
        name           string
        url            string
        icon_url       string
        proxy_icon_url string
}

pub fn (author MessageEmbedAuthor) to_json() json.Any {
        mut data := map[string]json.Any{}
        data['name'] = author.name
        data['url'] = author.url
        data['icon_url'] = author.icon_url
        data['proxy_icon_url'] = author.proxy_icon_url

        return data
}

pub struct MessageEmbedFooter {
pub mut:
        text           string
        icon_url       string
        proxy_icon_url string
}

pub fn (footer MessageEmbedFooter) to_json() json.Any {
        mut data := map[string]json.Any{}
        data['text'] = footer.text
        data['icon_url'] = footer.icon_url
        data['proxy_icon_url'] = footer.proxy_icon_url

        return data
}

pub struct MessageEmbedField {
pub mut:
        name   string
        value  string
        inline bool
}

pub fn (field MessageEmbedField) to_json() json.Any {
        mut data := map[string]json.Any{}
        data['name'] = field.name
        data['value'] = field.value
        data['inline'] = field.inline
        return data
}

pub fn (fields []MessageEmbedField) to_json() json.Any {
        mut data := []json.Any{}
        for field in fields {
                data << field.to_json()
        }
        return data
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

pub struct MessagePayload {
pub mut:
        content string
        embeds  []MessageEmbed
        tts     bool
}

pub struct CreateChannelData {
pub mut:
        name                string
        topic               string
        bitrate             int
        user_limit          int
        rate_limit_per_user int
        position            int
        parent_id           string
        nsfw                bool
}