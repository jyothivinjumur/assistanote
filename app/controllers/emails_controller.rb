class EmailsController < ApplicationController
  before_action :set_email, only: [:show, :edit, :update, :destroy, :vote]

  skip_before_filter :require_login

  # GET /emails
  # GET /emails.json
  def index

    @emails = Email.all
    @emails = Email.paginate(:page => params[:page])
  end

  # GET /emails/1
  # GET /emails/1.json
  def show
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
    @email.liked_by current_user    
    redirect_to @email
    
  end

  def downvote
    @email = Email.find(params[:id])
    @email.downvote_from current_user
    redirect_to @email    
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

  def readfile
    content = File.read(Rails.application.config.enronfiles + @email.reference_id)
    mail = Mail.read(Rails.application.config.enronfiles + @email.reference_id)   

    toArray = convertToArr(mail.to)
    fromArray = convertToArr(mail.from)
    ccArray = convertToArr(mail.cc)     
    # Get all senders and recipients of email in one array
    allPeople = toArray + fromArray + ccArray
    allPeople = allPeople.compact

    score = ""

    # Get all people (nodes) referenced in the email
    relations = @email.relation



    # content = content.gsub("\n", "<br/><br/>")
    

    # prepare output
    output = ""


    # output += "Date: #{mail.date.to_s} \n"
    # output += "From: #{fromArray} [#{from_nodename}] [#{from_score}]\n"
    # output += "To: #{toArray} \n"
    # output += "CC: #{ccArray} \n"
    # output += "#{referenced_nodes_scores.inspect} \n"
    output += "#{score} \n"    
    output += HTMLEntities.new.encode(content)

    unless relations.nil? 
      referenced_nodes = relations.recipient.split(",") << relations.node   
      # Get all nodes and their associated scores
      referenced_nodes_scores =  getscore(referenced_nodes)

      allPeople.each do |person|
        score2 = find_score(person, referenced_nodes_scores)
        #output = output.gsub(person, "<b><font color=\"red\")>#{person}::#{score2}</font></b>")

        #output = output.gsub(person, "<span class=\"btn btn-default mytooltip\" title=\"#{score2}\">#{person}</span>")

        output = output.gsub(person, "<code class=\"mytooltip\" title=\"#{score2}\">#{person}</code>")


        output = output.gsub("\r\n", "<br />")
      end
    end

    output

    # output += "-----------------------------------------------\n"
    # output += "-----------------------------------------------\n"
    # output += "-----------------------------------------------\n"
    # output += "-----------------------------------------------\n"
    # output += File.read(Rails.application.config.enronfiles + @email.reference_id)

  end
  helper_method :readfile

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

  def getscore(ids)
    scores = Hash.new
    ids.each do |id|
      scores["#{Prnode.find_by_pgid(id.to_i).pgnodename}"] = Prnode.find_by_pgid(id.to_i).pgscore      
    end
    scores
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
