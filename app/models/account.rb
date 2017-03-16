class Account < ApplicationRecord
  belongs_to :user,optional: true

  scope :pending, ->  { where(:state => 0) }
  scope :register_succ, ->  { where(:state => 1) }
  scope :register_fail, ->  { where(:state => 2) }
  scope :activate_succ, ->  { where(:state => 3) }
  scope :activate_fail, ->  { where(:state => 4) }
  scope :waiting_activate, ->  { where(:state => 5) }
  scope :waiting_register, ->  { where(:state => 6) }

  scope :by_user_id, ->(user_id) { where(user_id: user_id)}
  validates :mail, :uniqueness =>true
  after_create :init_parent_user_id
  def init_parent_user_id
    if self.user.present? && self.user.root?
       self.parent_user_id = self.user_id
      self.save
    end
    if self.parent_user_id.blank?
      self.parent_user_id = self.user.parent.id if self.user.present? && self.user.parent.present?
      self.save
    end
  end
  STATES = {
    "0" => "初始化",
    "1" => "注册成功",
    "2" => "注册失败",
    "3" => "激活成功",
    "4" => "激活失败",
    "5" => "待激活",
    "6" => "待注册",
    "7" => "已经卖出"
  }
  def state_to_s
    STATES[self.state.to_s]
  end

  def as_json
    {
      "id": self.id,
      "login": self.login,
      "password": self.password,
      "mail": self.mail,
      "mailpassword": self.mailpassword,
      "activate_url": self.activate_url,
      "state": self.state
    }
  end

  def self.clear_waiting_register
    self.waiting_register.where("updated_at < ?",30.minutes.ago).each do |account|
      account.state = 2
      account.save
    end
  end

  def self.clear_waiting_activate
    self.waiting_activate.where("updated_at < ?",30.minutes.ago).each do |account|
      account.state = 4
      account.save
    end
  end

  def self.pick_one_pending_account(user_id = 1)
    pending_account = self.pending.by_user_id(user_id).order("id asc").first
    if pending_account.present?
      pending_account.state = 6
      pending_account.save
    end
    if pending_account.state == 6
      return pending_account
    else
      return nil
    end
  end

  def self.pick_one_waiting_activate_account(user_id = 1)
    self.waiting_activate.by_user_id(user_id).order("id asc").first
  end

  def self.get_and_parse_activate_url
    self.register_succ.each do |c|
      begin
        Mail.defaults do
          retriever_method :pop3, :address    => "md-hk-6.webhostbox.net",
                                  :port       => 995,
                                  :user_name  => "#{c.mail}",
                                  :password   => "#{c.mailpassword}",
                                  :enable_ssl => true
        end
        mails = Mail.all.select{|c| c.from.include?("appleid@id.apple.com")}
        mails.each do |_mail|
          _link =  URI.extract(_mail.parts.last.body.decoded).select{|c| c.include?("IDMSEmailVetting")}.first
          if _link.present?
            c.activate_url = _link
            c.state = 5
            c.save
          end
        end
      rescue Exception => e
        
      end
    end
  end
  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.csv' then Roo::CSV.new(file.path)
    when '.xls' then Roo::Excel.new(file.path)
    when '.xlsx' then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      used_column_names = column_names - ["state","user_id","created_at","updated_at"]
      csv << used_column_names
      all.each do |product|
        csv << product.attributes.values_at(*used_column_names)
      end
    end
  end
end
