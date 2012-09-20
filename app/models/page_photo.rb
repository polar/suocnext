class PagePhoto < ActiveRecord::Base
  # Only here for initial migration to SUOC 2.0
  # TODO: remove
  #has_attachment prepare_options_for_attachment_fu(AppConfig.page_photo['attachment_fu_options'])

  #validates_as_attachment
end
