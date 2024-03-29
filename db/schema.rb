# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120919181899) do

  create_table "acct_account_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acct_accounts", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "account_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "reports",         :default => true
  end

  create_table "acct_accounts_acct_actions", :id => false, :force => true do |t|
    t.integer "acct_account_id"
    t.integer "acct_action_id"
  end

  create_table "acct_action_sets", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "ledger_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acct_action_sets_acct_actions", :id => false, :force => true do |t|
    t.integer "acct_action_id"
    t.integer "acct_action_set_id"
  end

  create_table "acct_action_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acct_actions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "account_id"
    t.integer  "category_id"
    t.integer  "action_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acct_categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acct_entries", :force => true do |t|
    t.integer  "acct_transaction_id"
    t.integer  "account_id"
    t.integer  "category_id"
    t.decimal  "debit",               :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "credit",              :precision => 12, :scale => 2, :default => 0.0
    t.string   "description"
    t.integer  "recorded_by_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acct_ledger_accounts", :force => true do |t|
    t.text     "label"
    t.integer  "account_id"
    t.integer  "ledger_id"
    t.boolean  "show_if_zero"
    t.boolean  "balances_in"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acct_ledgers", :force => true do |t|
    t.text     "name"
    t.text     "slug"
    t.text     "description"
    t.integer  "target_account_id"
    t.text     "subtotal_label"
    t.text     "total_label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "acct_transactions", :force => true do |t|
    t.integer  "recorded_by_id"
    t.integer  "target_account_id"
    t.integer  "acct_action_id"
    t.string   "description"
    t.date     "date"
    t.decimal  "amount",            :precision => 12, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.string   "action",     :limit => 50
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at"
  end

  add_index "activities", ["created_at"], :name => "index_activities_on_created_at"
  add_index "activities", ["user_id"], :name => "index_activities_on_user_id"

  create_table "ads", :force => true do |t|
    t.string   "name"
    t.text     "html"
    t.integer  "frequency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "location"
    t.boolean  "published",        :default => false
    t.boolean  "time_constrained", :default => false
    t.string   "audience",         :default => "all"
  end

  create_table "albums", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "view_count"
  end

  create_table "assets", :force => true do |t|
    t.string   "asset_file_name"
    t.integer  "width"
    t.integer  "height"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "thumbnail"
    t.integer  "parent_id"
    t.datetime "asset_updated_at"
  end

  create_table "authorizations", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "nickname"
    t.string   "email"
    t.string   "picture_url"
    t.string   "access_token"
    t.string   "access_token_secret"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "categories", :force => true do |t|
    t.string "name"
    t.text   "tips"
    t.string "new_post_text"
    t.string "nav_text"
  end

  create_table "cert_member_certs", :force => true do |t|
    t.integer  "cert_org_id"
    t.integer  "member_id"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "comment"
    t.integer  "verified_by_id"
    t.date     "verified_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cert_orgs", :force => true do |t|
    t.text     "name"
    t.text     "description"
    t.integer  "position"
    t.integer  "cert_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cert_types", :force => true do |t|
    t.text     "name"
    t.text     "description"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "choices", :force => true do |t|
    t.integer "poll_id"
    t.string  "description"
    t.integer "votes_count", :default => 0
  end

  create_table "clippings", :force => true do |t|
    t.string   "url"
    t.integer  "user_id"
    t.string   "image_url"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "favorited_count", :default => 0
  end

  add_index "clippings", ["created_at"], :name => "index_clippings_on_created_at"

  create_table "club_activities", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "tagline"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "club_affiliations", :force => true do |t|
    t.string   "name"
    t.string   "description",       :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "requires_memberid", :default => true
  end

  create_table "club_announcements", :force => true do |t|
    t.string   "dates",      :default => ""
    t.string   "what",       :default => ""
    t.string   "contact",    :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "club_chairmanships", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "club_chairs", :force => true do |t|
    t.integer  "member_id"
    t.integer  "activity_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "club_leaders", :force => true do |t|
    t.integer  "member_id"
    t.integer  "leadership_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "verified_by_id"
    t.date     "verified_date"
  end

  create_table "club_leaderships", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "tagline"
    t.integer  "position"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "club_login_messages", :force => true do |t|
    t.date     "date"
    t.text     "message"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "club_member_statuses", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "club_members", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "club_members_club_trip_registrations", :id => false, :force => true do |t|
    t.integer "club_member_id"
    t.integer "club_trip_registration_id"
  end

  create_table "club_membership_types", :force => true do |t|
    t.string   "name"
    t.string   "description", :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "club_memberships", :force => true do |t|
    t.integer  "member_id"
    t.integer  "member_type_id",      :default => 0
    t.integer  "acct_transaction_id"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "club_officers", :force => true do |t|
    t.integer  "member_id"
    t.integer  "office_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "club_offices", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "tagline"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "club_roles", :force => true do |t|
    t.string  "title"
    t.integer "club_member_id"
  end

  create_table "club_trip_registrations", :force => true do |t|
    t.integer  "leader_id"
    t.integer  "leadership_id"
    t.text     "email"
    t.text     "phone"
    t.text     "trip_name"
    t.date     "departure_date"
    t.date     "return_date"
    t.text     "mode_of_transport"
    t.text     "location"
    t.text     "overnight_location"
    t.text     "overnight_phone"
    t.text     "notes"
    t.text     "attendees"
    t.date     "submit_date"
    t.text     "submit_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "club_trip_registrations_configurations", :force => true do |t|
    t.text     "notification_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "club_trips", :force => true do |t|
    t.string   "trip"
    t.string   "swhen"
    t.string   "where"
    t.string   "meet"
    t.string   "e_room"
    t.string   "limit"
    t.string   "leader"
    t.string   "contact"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comatose_page_versions", :force => true do |t|
    t.integer  "page_id"
    t.integer  "version"
    t.integer  "parent_id"
    t.text     "full_path"
    t.string   "title"
    t.string   "slug"
    t.string   "keywords"
    t.text     "body"
    t.string   "filter_type", :limit => 25, :default => "Textile"
    t.string   "author"
    t.integer  "position",                  :default => 0
    t.datetime "updated_on"
    t.datetime "created_on"
    t.string   "mount"
  end

  create_table "comatose_pages", :force => true do |t|
    t.integer  "parent_id"
    t.text     "full_path"
    t.string   "title"
    t.string   "slug"
    t.string   "keywords"
    t.text     "body"
    t.string   "filter_type",        :limit => 25, :default => "Textile"
    t.integer  "position",                         :default => 0
    t.integer  "version"
    t.datetime "updated_on"
    t.datetime "created_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mount"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.datetime "created_at",                                       :null => false
    t.integer  "commentable_id",                 :default => 0,    :null => false
    t.string   "commentable_type", :limit => 15, :default => "",   :null => false
    t.integer  "user_id",                        :default => 0,    :null => false
    t.integer  "recipient_id"
    t.text     "comment"
    t.string   "author_name"
    t.string   "author_email"
    t.string   "author_url"
    t.string   "author_ip"
    t.boolean  "notify_by_email",                :default => true
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["created_at"], :name => "index_comments_on_created_at"
  add_index "comments", ["recipient_id"], :name => "index_comments_on_recipient_id"
  add_index "comments", ["user_id"], :name => "fk_comments_user"

  create_table "contests", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "begin_date"
    t.datetime "end_date"
    t.text     "raw_post"
    t.text     "post"
    t.string   "banner_title"
    t.string   "banner_subtitle"
  end

  create_table "countries", :force => true do |t|
    t.string "name"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "description"
    t.integer  "metro_area_id"
    t.string   "location"
    t.boolean  "allow_rsvp",    :default => true
  end

  create_table "favorites", :force => true do |t|
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "favoritable_type"
    t.integer  "favoritable_id"
    t.integer  "user_id"
    t.string   "ip_address",       :default => ""
  end

  add_index "favorites", ["user_id"], :name => "fk_favorites_user"

  create_table "forums", :force => true do |t|
    t.string  "name"
    t.string  "description"
    t.integer "topics_count",     :default => 0
    t.integer "sb_posts_count",   :default => 0
    t.integer "position"
    t.text    "description_html"
    t.string  "owner_type"
    t.integer "owner_id"
  end

  create_table "friendship_statuses", :force => true do |t|
    t.string "name"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "friend_id"
    t.integer  "user_id"
    t.boolean  "initiator",            :default => false
    t.datetime "created_at"
    t.integer  "friendship_status_id"
  end

  add_index "friendships", ["friendship_status_id"], :name => "index_friendships_on_friendship_status_id"
  add_index "friendships", ["user_id"], :name => "index_friendships_on_user_id"

  create_table "homepage_features", :force => true do |t|
    t.datetime "created_at"
    t.string   "url"
    t.string   "title"
    t.text     "description"
    t.datetime "updated_at"
    t.string   "image_content_type"
    t.string   "image_file_name"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "image_file_size"
    t.integer  "width"
    t.integer  "height"
    t.datetime "image_updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.string   "email_addresses"
    t.string   "message"
    t.integer  "user_id"
    t.datetime "created_at"
  end

  create_table "message_threads", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "message_id"
    t.integer  "parent_message_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "sender_deleted",    :default => false
    t.boolean  "recipient_deleted", :default => false
    t.string   "subject"
    t.text     "body"
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
  end

  create_table "metro_areas", :force => true do |t|
    t.string  "name"
    t.integer "state_id"
    t.integer "country_id"
    t.integer "users_count", :default => 0
  end

  create_table "moderatorships", :force => true do |t|
    t.integer "forum_id"
    t.integer "user_id"
  end

  add_index "moderatorships", ["forum_id"], :name => "index_moderatorships_on_forum_id"

  create_table "monitorships", :force => true do |t|
    t.integer "topic_id"
    t.integer "user_id"
    t.boolean "active",   :default => true
  end

  create_table "offerings", :force => true do |t|
    t.integer "skill_id"
    t.integer "user_id"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "published_as", :limit => 16, :default => "draft"
    t.boolean  "page_public",                :default => true
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  create_table "paypal_reunion_payments", :force => true do |t|
    t.integer  "member_id"
    t.text     "ipn_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "photo_content_type"
    t.string   "photo_file_name"
    t.integer  "photo_file_size"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.integer  "album_id"
    t.integer  "view_count"
    t.datetime "photo_updated_at"
  end

  add_index "photos", ["created_at"], :name => "index_photos_on_created_at"
  add_index "photos", ["parent_id"], :name => "index_photos_on_parent_id"

  create_table "polls", :force => true do |t|
    t.string   "question"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_id"
    t.integer  "votes_count", :default => 0
  end

  add_index "polls", ["created_at"], :name => "index_polls_on_created_at"
  add_index "polls", ["post_id"], :name => "index_polls_on_post_id"

  create_table "posts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "raw_post"
    t.text     "post"
    t.string   "title"
    t.integer  "category_id"
    t.integer  "user_id"
    t.integer  "view_count",                               :default => 0
    t.integer  "contest_id"
    t.integer  "emailed_count",                            :default => 0
    t.integer  "favorited_count",                          :default => 0
    t.string   "published_as",               :limit => 16, :default => "draft"
    t.datetime "published_at"
    t.boolean  "send_comment_notifications",               :default => true
  end

  add_index "posts", ["category_id"], :name => "index_posts_on_category_id"
  add_index "posts", ["published_as"], :name => "index_posts_on_published_as"
  add_index "posts", ["published_at"], :name => "index_posts_on_published_at"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "rsvps", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "attendees_count"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "sb_posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "forum_id"
    t.text     "body_html"
    t.string   "author_name"
    t.string   "author_email"
    t.string   "author_url"
    t.string   "author_ip"
  end

  add_index "sb_posts", ["forum_id", "created_at"], :name => "index_sb_posts_on_forum_id"
  add_index "sb_posts", ["user_id", "created_at"], :name => "index_sb_posts_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "sessid"
    t.text     "data"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "sessions", ["sessid"], :name => "index_sessions_on_sessid"

  create_table "skills", :force => true do |t|
    t.string "name"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "states", :force => true do |t|
    t.string "name"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"
  add_index "taggings", ["taggable_id"], :name => "index_taggings_on_taggable_id"
  add_index "taggings", ["taggable_type"], :name => "index_taggings_on_taggable_type"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "taggings_count", :default => 0
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "topics", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hits",           :default => 0
    t.integer  "sticky",         :default => 0
    t.integer  "sb_posts_count", :default => 0
    t.datetime "replied_at"
    t.boolean  "locked",         :default => false
    t.integer  "replied_by"
    t.integer  "last_post_id"
  end

  add_index "topics", ["forum_id", "replied_at"], :name => "index_topics_on_forum_id_and_replied_at"
  add_index "topics", ["forum_id", "sticky", "replied_at"], :name => "index_topics_on_sticky_and_replied_at"
  add_index "topics", ["forum_id"], :name => "index_topics_on_forum_id"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.text     "description"
    t.integer  "avatar_id"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "persistence_token"
    t.text     "stylesheet"
    t.integer  "view_count",                           :default => 0
    t.boolean  "vendor",                               :default => false
    t.string   "activation_code",        :limit => 40
    t.datetime "activated_at"
    t.integer  "state_id"
    t.integer  "metro_area_id"
    t.string   "login_slug"
    t.boolean  "notify_comments",                      :default => true
    t.boolean  "notify_friend_requests",               :default => true
    t.boolean  "notify_community_news",                :default => false
    t.integer  "country_id"
    t.boolean  "featured_writer",                      :default => false
    t.datetime "last_login_at"
    t.string   "zip"
    t.date     "birthday"
    t.string   "gender"
    t.boolean  "profile_public",                       :default => true
    t.integer  "activities_count",                     :default => 0
    t.integer  "sb_posts_count",                       :default => 0
    t.datetime "sb_last_seen_at"
    t.integer  "role_id"
    t.string   "type"
    t.string   "club_aliases"
    t.string   "club_memberid"
    t.date     "club_start_date"
    t.date     "club_end_date"
    t.integer  "club_member_status_id"
    t.string   "club_contact"
    t.integer  "club_affiliation_id"
    t.date     "club_grad_year"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count",                          :default => 0
    t.integer  "failed_login_count",                   :default => 0
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
  end

  add_index "users", ["activated_at"], :name => "index_users_on_activated_at"
  add_index "users", ["avatar_id"], :name => "index_users_on_avatar_id"
  add_index "users", ["created_at"], :name => "index_users_on_created_at"
  add_index "users", ["featured_writer"], :name => "index_users_on_featured_writer"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["login_slug"], :name => "index_users_on_login_slug"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["vendor"], :name => "index_users_on_vendor"

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "poll_id"
    t.integer  "choice_id"
    t.datetime "created_at"
  end

end
