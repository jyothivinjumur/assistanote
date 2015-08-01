require 'csv'

class EmailsController < ApplicationController
  before_action :set_email, only: [:show, :edit, :update, :destroy, :vote]

  skip_before_filter :require_login

  # GET /emails
  # GET /emails.json
  def index
    @emails = Email.where("category=?", current_user.id%2).paginate(:page => params[:page])
  end

  # GET /emails/1
  # GET /emails/1.json
  def show
    TRACKER.track(current_user['email'], "READ_EMAIL", {"email_id" => @email.id, "email_reference" => @email.reference_id})
  end

  # GET /emails/new
  def new
    @email = Email.new
  end

  # GET /emails/1/edit
  def edit
  end

  # POST /emails
  # POST /emails.json
  def create
    @email = Email.new(email_params)

    respond_to do |format|
      if @email.save
        format.html { redirect_to @email, notice: 'Email was successfully created.' }
        format.json { render :show, status: :created, location: @email }
      else
        format.html { render :new }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /emails/1
  # PATCH/PUT /emails/1.json
  def update
    respond_to do |format|
      if @email.update(email_params)
        format.html { redirect_to @email, notice: 'Email was successfully updated.' }
        format.json { render :show, status: :ok, location: @email }
      else
        format.html { render :edit }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @email.destroy
    respond_to do |format|
      format.html { redirect_to emails_url, notice: 'Email was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  #->Prelang (voting/acts_as_votable)
  def vote

    direction = params[:direction]

    # Make sure we've specified a direction
    raise "No direction parameter specified to #vote action." unless direction

    # Make sure the direction is valid
    unless ["like", "bad"].member? direction
      raise "Direction '#{direction}' is not a valid direction for vote method."
    end

    @email.vote_by voter: current_user, vote: direction

    redirect_to action: :index
  end

  def upvote
    @email = Email.find(params[:id])

    if current_user.voted_down_on? @email
      TRACKER.track(current_user['email'], "CHANGED_TO_UPVOTE",{"email_id" => @email.id, "email_reference" => @email.reference_id})
    else
      TRACKER.track(current_user['email'], "UPVOTE",{"email_id" => @email.id, "email_reference" => @email.reference_id})
    end

    @email.liked_by current_user
    redirect_to emails_path

  end

  def downvote
    @email = Email.find(params[:id])

    if current_user.voted_up_on? @email
      TRACKER.track(current_user['email'], "CHANGED_TO_DOWNVOTE",{"email_id" => @email.id, "email_reference" => @email.reference_id})
    else
      TRACKER.track(current_user['email'], "DOWNVOTE",{"email_id" => @email.id, "email_reference" => @email.reference_id})
    end


    @email.downvote_from current_user


    redirect_to emails_path
    #redirect_to @email
  end

  def hasvoted(email)
    email.votes_for.down.by_type(current_user).inspect
    #if email.votes_for.size > 0
    #  true
    #else
    #  false
    #end
  end
  helper_method :hasvoted


  def getblurb(content)
    mail = Mail.read_from_string(content)
    sender = "#{mail.from}"[0..30].gsub!(/[^0-9A-Za-z\.@]/, '')
    subject = "#{mail.subject}"[0..90]

    [sender, subject]


  end
  helper_method :getblurb

  def readfile
    #TRACKER.track(current_user['email'], "email_READ")

    content = @email.content
    mail = Mail.read_from_string(content)

    toArray = convertToArr(mail.to)
    fromArray = convertToArr(mail.from)
    ccArray = convertToArr(mail.cc)     
    # Get all senders and recipients of email in one array
    allPeople = toArray + fromArray + ccArray
    allPeople = allPeople.compact

    score = ""

    # Get all people (nodes) referenced in the email
    relations = @email.relation

    output = ""

    output += "#{score} \n"    
    output += HTMLEntities.new.encode(content.force_encoding("UTF-8"))

    unless relations.nil? 
      referenced_nodes = relations.recipient.split(",") << relations.node   
      # Get all nodes and their associated scores
      referenced_nodes_scores =  getscore(referenced_nodes)
      referenced_nodes_roles =  getnoderole(referenced_nodes)

      allPeople.each do |person|
        score2 = find_score(person, referenced_nodes_scores)
        roleInfo=find_role(person,referenced_nodes_roles)

        if (score2.to_f >= 0.7)
          output = output.gsub(person, "<code class=\"mytooltip my-code-80orhigher\" title=\"#{roleInfo}\">#{person}</code>")
        elsif (score2.to_f.between?(0.3,0.7))
          output = output.gsub(person, "<code class=\"mytooltip my-code-50to80\" title=\"#{roleInfo}\">#{person}</code>")
        elsif (score2.to_f.between?(0.1,0.3))
          output = output.gsub(person, "<code class=\"mytooltip my-code-20to50\" title=\"#{roleInfo}\">#{person}</code>")
        else
          output = output.gsub(person, "<code class=\"mytooltip my-code-20less\" title=\"#{roleInfo}\">#{person}</code>")
        end

        output = output.gsub("\n", "<br />")

      end
    end

    highlight_terms(output)

  end
  helper_method :readfile


  def highlight_terms(text)
    words = {}
    #Termscore.all.each do |t|
    Termscore.where("score>=1").each do |t|
      words[t.term] = t.score

      #text.sub!(/#{t.term}/, "<code class=\"mytooltip\" title=\"#{t.score}\"><u>#{t.term}</u></code>")


      if (t.score.to_f >= 6)
        text.gsub!(/([\s\.\,\;]#{t.term}[\s\.\,\;])/i, "<b class=\"text-high-importance\" title=\"#{t.score}\">\\1</b>")
      elsif (t.score.to_f.between?(2,6))
        text.gsub!(/([\s\.\,\;]#{t.term}[\s\.\,\;])/i, "<b class=\"text-mid-importance\" title=\"#{t.score}\">\\1</b>")
      elsif (t.score.to_f.between?(1,2))
        text.gsub!(/([\s\.\,\;]#{t.term}[\s\.\,\;])/i, "<b class=\"text-low-importance\" title=\"#{t.score}\">\\1</b>")
      else
        text.gsub!(/([\s\.\,\;]#{t.term}[\s\.\,\;])/i, "<b class=\"text-neg-importance\" title=\"#{t.score}\">\\1</b>")
        # text.gsub!(/([\s\.\,\;]#{t.term}[\s\.\,\;])/i, "<b  title=\"#{t.score}\">\\1</b>")
      end
    end
    "#{text}"
  end

  def gethistory
    data = []
    CSV.foreach("public/assets/dateScores.csv") do |r|
      a,b = r
      data << [a.to_i, b.to_f]
    end

    ActiveSupport::JSON.encode(data)
  end
  helper_method :gethistory

  def getdate
    content = @email.content
    mail = Mail.read_from_string(content)

    mail.date.strftime('%Q')

  end
  helper_method :getdate




  def getscorehash(node)
    series = []
    scores = History.select(:sent_date,:score).where(:node => node)
    scores.each do |d|
      data = {}
      unless d.score < 0.02
        data[d.sent_date] = d.score
        series << {:name => Prnode.find_by_pgid(node.to_i).pgnodename, :data => data}
      end
    end
    series
  end

  def node_color_matcher(node)
    color = nil
    if (getscorefornode(node) > 0.5)
      color = "#E63E00"
    elsif (getscorefornode(node).between?(0.2, 0.5))
      color = "#FF6A33"
    else
      color = "#FFC7B2"
    end
    color
  end



  def convertToArr(mailtofromcc)
    tArr = Array.new
    if (mailtofromcc.instance_of? String)  
      tArr = mailtofromcc.split(",") 
    elsif mailtofromcc.nil? || mailtofromcc.empty?
      tArr = []    
    else
      mailtofromcc.each {|to| tArr << to}
    end  
  end

  def show_attachments
    @email.attachments
  end
  helper_method :show_attachments


  def find_score(node, referenced_nodes_scores)
    score = 0
    allnodes = []
    referenced_nodes_scores.each do |email, score|
      allnodes << email
    end
    match = FuzzyMatch.new(allnodes).find(node)

    if match.nil?
      score = 0
    else
      score = referenced_nodes_scores["#{match}"]
    end

    # "===========> [#{node}]" + " [#{match}:#{score}] \n"
    score.to_s

  end

  def find_role(node, referenced_nodes_roles)
    role = ''
    allnodes = []
    referenced_nodes_roles.each do |email, role|
      allnodes << email
    end
    match = FuzzyMatch.new(allnodes).find(node)

    if match.nil?
      role = 'No Information'
    else
      role = referenced_nodes_roles["#{match}"]
    end

    # "===========> [#{node}]" + " [#{match}:#{score}] \n"
    role.to_s
  end

  def getscore(ids)
    scores = Hash.new
    ids.each do |id|
      scores["#{Prnode.find_by_pgid(id.to_i).pgnodename}"] = Prnode.find_by_pgid(id.to_i).relative_rank
    end
    scores
  end

  def getnoderole(ids)
    roles = Hash.new
    ids.each do |id|
      roles["#{Prnode.find_by_pgid(id.to_i).pgnodename}"] = Prnode.find_by_pgid(id.to_i).Role
    end
    roles
  end

  def getscorefornode(node)
    Prnode.find_by_pgid(node.to_i).relative_rank
  end

  # returns [nodename] [score] ordered by node_text
  # def getscore(node_arr, node_text)
  #   ret = []
  #   node_text.each do |n1|
  #     node_arr.each do |n2|
  #       if()
  #     end
  #   end
  # end

  def geternode(text)
    #@prnode = Prnode.where("pgscore > 0").first.pgnodename

    @prnodes = Prnode.select(:pgnodename)

    puts "DEBUGHEeeeeeeeeeeeeeeee"
    # puts @prnodes.inspect
    #[@prnodes.first.pgnodename, @prnodes.first.pgscore]

    FuzzyMatch.new(@prnodes).find(text)

  end
  helper_method :geternode

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email
      @email = Email.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_params
      params.require(:email).permit(:reference_id, :path)
    end
end
