module valkyria

import eb
import net.websocket
import time
import os
import x.json2 as json

pub struct GatewayPacket {
mut: 
    op   int
    d    json.Any
    s    int
    t    string
}

pub struct HelloPacket {
mut:
    heartbeat_interval i64
}

pub struct HeartbeatPacket {
    op   json.Any
    d    int
}

struct Identify {
	token string
	properties IdentifyProperties
	intents Intent
}

struct IdentifyProperties {
	os string = os.user_os()
	browser string = 'valkyria'
	device string = 'valkyria'
}


struct SendIdentifyPacket {
    op  u8
    d   Identify
}

pub struct Client {
    token      string
    intents    Intent
pub mut:  
    ws                 &websocket.Client
    sid                string
    seq                int
    last_heartbeat     i64
    heartbeat_interval i64
    heartbeat_asked    bool
    events     &eb.EventBus
}

pub struct Ready {
pub mut:
	v                int
	user             User
	guilds           []UnavailableGuild
	session_id       string
	shard            [2]int
	application      ApplicationStruct
}

pub struct ApplicationStruct {
pub mut:
	id   string
	flags int
}
pub struct UnavailableGuild {
pub mut:
	id          string
	unavailable bool
}

pub struct User {
pub mut:
	id            string
	username      string
	discriminator string
	avatar        Avatar
	bot           bool
	system        bool
	mfa_enabled   bool
	banner        string
	accent_color   int
	locale        string
	verified      bool
	email         string
	flags         UserFlag
	premium_type  PremiumType
	public_flags  UserFlag
}

pub type UserFlag = int

pub enum PremiumType {
	none_type
	nitro_classic
	nitro
	
}

pub struct Channel {
pub mut:
	id                    string
	@type                 ChannelType
	guild_id              string
	position              int
	permission_overwrites PermissionOverwrite
	name                  string
	topic                 string
	nsfw                  bool
	last_message_id       string
	bitrate               int
	user_limit            int
	rate_limit_per_user   int
	recipients            []User
	icon                  string
	owner_id              string
	application_id        string
	parent_id             string
	last_pin_timestamp    time.Time
	rtc_region             string
	video_quality_mode     int
	message_count          int
	member_count           int
    thread_metadata	   ThreadMetadata
	member                ThreadMember
default_auto_archive_duration  int
  permissions                 string

}

enum ChannelType {
	guild_text
	dm
	guild_voice
	group_dm
	guild_category
	guild_news
	guild_store
}

enum PermissionOverwriteType {
	role
	user
}

struct PermissionOverwrite {
pub mut:
	id    string
	@type PermissionOverwriteType
	allow string
	deny  string
}

pub struct Avatar {
	user_id string
pub:
	hash string
}

pub struct ThreadMetadata {
	archived bool
	auto_archive_duration int
	archive_timestamp   int
	locked           bool
	invitable        bool
	create_timestamp  int
}

pub struct ThreadMember {
	id  string
	flags  int
	user_id string
	join_timestamp int
}

pub struct Message {
pub mut:
	id                 string
	channel_id         string
	guild_id           string
	author             User
	member             Member
	content            string
	timestamp          time.Time
	edited_timestamp   time.Time
	tts                bool
	mention_everyone   bool
	mentions           []User
	mention_roles      []string
	mention_channels   []ChannelMention
	attachments        []Attachment
	embeds             []Embed
	reactions          []Reaction
	nonce              string
	pinned             bool
	webhook_id         string
	@type              MessageType
	activity           MessageActivity
	application        MessageApplication
	message_reference  MessageReference
	referenced_message &Message = voidptr(0)
	sticker_items         []StickerItems
	flags              MessageFlag
	interaction         InteractionObject
	thread              Channel
    components          []MessageComponent

}
pub struct ChannelMention {
pub mut:
	id       string
	guild_id string
	@type    ChannelType
	name     string
}

pub struct Reaction {
pub mut:
	count int
	me    bool
	emoji Emoji
}

pub struct Role {
pub mut:
	id          string
	name        string
	color       int
	hoist       bool
	position    int
	permission  string
	managed     bool
	mentionable bool
}

pub struct Emoji {
pub mut:
	id    string
	name  string
	roles []Role
}

pub struct Embed {
pub mut:
	title       string
	description string
	url         string
	timestamp   time.Time
	color       int
	footer      EmbedFooter
	image       EmbedImage
	thumbnail   EmbedThumbnail
	video       EmbedVideo
	provider    EmbedProvider
	author      EmbedAuthor
	fields      []EmbedField
}

pub struct EmbedVideo {
pub mut:
	url    string
	height int
	width  int
}

pub struct InteractionObject {
pub mut:
	id  string
	@type InteractionType
	name  string
	user   User
	member Member
}
pub struct StickerItems {
pub mut:
	id string
	name string
	format_type StickerFormatType
}
pub struct Member {
pub mut:
	user          User
	nick          string
	avatar        string
	roles         []string
	joined_at     time.Time
	premium_since time.Time
	deaf          bool
	mute          bool
	pending       bool
	permissions  string
	communication_disabled_util time.Time
}

pub struct MessageApplication {
pub mut:
	id          string
	cover_image string
	description string
	icon        string
	name        string
}

pub enum StickerFormatType {
	png = 1
	apng = 2
	lottie = 3
}
pub enum MessageType {
	default
	recipient_add
	recipient_remove
	call
	channel_name_change
	channel_icon_change
	channel_pinned_message
	guild_member_join
	user_premium_guild_subscription
	user_premium_guild_subscription_tier_1
	user_premium_guild_subscription_tier_2
	user_premium_guild_subscription_tier_3
	channel_follow_add
	guild_discovery_disqualified
	guild_discovery_requalified
	thread_created = 18
	reply = 19
	chat_input_command
	thread_starter_message
	guild_invite_reminder
	context_menu_command
}

pub struct MessageActivity {
pub mut:
	@type    MessageActivityType
	party_id string
}

pub enum MessageActivityType {
	join = 1
	spectate = 2
	listen = 3
	join_request = 5
}

pub struct MessageReference {
pub mut:
	message_id string
	channel_id string
	guild_id   string
}

pub type MessageFlag = byte

pub const (
	crossposted            = MessageFlag(1 << 0)
	is_crosspost           = MessageFlag(1 << 1)
	suppress_embeds        = MessageFlag(1 << 2)
	source_message_deleted = MessageFlag(1 << 3)
	urgent                 = MessageFlag(1 << 4)
)

pub struct Interaction {
pub mut:
	id         string
	application_id  string
	@type      InteractionType                   [json: 'type']
	data       ApplicationCommandInteractionData
	guild_id   string
	channel_id string
	member     Member
	token      string
	version    int
	message     Message
	locale      string
	guild_locale  string
}

pub enum InteractionType {
	ping = 1
	application_command = 2
	message_component = 3
	application_command_autocomplete = 4
}

pub struct ApplicationCommandInteractionData {
pub mut:
	id      string
	name    string
	@type    int   //TODO
	resolved  string
	options string  //TODO
	custom_id  string
	component_type int
	values       string  //TODO
	target_id   string //TODO
}

pub enum ApplicationCommandType {
	chat_input = 1
	user = 2
	message = 3
}

pub struct MessageComponent {
pub mut:
       @type ComponentType
	   custom_id string
	   disabled  bool
	   style  ButtonStyle
	   label string
	   emoji  PartialEmoji
	   url  string
	   options []SelectOptions
	   placeholder string
	   min_values int
	   max_values int
	   components []MessageComponent
}

pub struct SelectOptions {
pub mut:
	label string
	value string
	description string
	emoji PartialEmoji
	default bool
}
pub struct PartialEmoji {
pub mut:
	id string
	name string
	animated bool
}
pub enum ButtonStyle {
	primary = 1
	secondary = 2
	success = 3
	danger = 4
	link = 5
}

pub enum ComponentType {
	action_row = 1
	button = 2
	select_menu = 3
}

pub struct EmbedProvider {
pub mut:
	name string
	url  string
}


pub struct EmbedField {
pub mut:
	name   string
	value  string
	inline bool
}

pub struct EmbedAuthor {
pub mut:
	name           string
	url            string
	icon_url       string
	proxy_icon_url string
}

pub struct EmbedFooter {
pub mut:
	text           string
	icon_url       string
	proxy_icon_url string
}

pub struct EmbedImage {
pub mut:
	url       string
	proxy_url string
	height    int
	width     int
}

pub struct EmbedThumbnail {
pub mut:
	url       string
	proxy_url string
	height    int
	width     int
}

pub struct Attachment {
pub mut:
	id        string
	filename  string
	size      int
	url       string
	proxy_url string
	height    int
	width     int
}
