class Professional < ApplicationRecord
  belongs_to :client
  has_many :bankings
  has_many :products, :dependent => :destroy
  has_attached_file :logo, styles: {medium: "300x300#",  thumb: "100x100#" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/
end
