# rails-pack
Rails pack is a basic project for creating rails application from scratch. Rails pack includes devise, cancan, twitter bootstrep

#Installation Steps
Copy config/database-sample.yml and create a new file called config/database.yml file
Run "bundle install" in your project directory
Run "rake db:migrate"
Run "rake db:seed"


#Omni auth setup

```
<div class="row userInfo">
        <div class="col-xs-6 col-sm-6">
            <div class="control-group">
            <%= link_to  user_omniauth_authorize_path(:facebook), :class => 'btn btn-block btn-social btn-facebook' do %>
                <i class="fa fa-facebook"></i> Sign in with Facebook
            <% end %>

            <br />
            <%= link_to  user_omniauth_authorize_path(:twitter), :class => 'btn btn-block btn-social btn-twitter' do %>
                <i class="fa fa-twitter"></i> Sign in with Twitter
            <% end %>

            <br />
            <%= link_to  user_omniauth_authorize_path(:google_oauth2), :class => 'btn btn-block btn-social btn-google' do %>
                <i class="fa fa-google"></i> Sign in with Google
            <% end %>

            <br />
            <%= link_to  user_omniauth_authorize_path(:linkedin), :class => 'btn btn-block btn-social btn-linkedin' do %>
                <i class="fa fa-linkedin"></i> Sign in with Linked In
            <% end %>
          </div>
        </div>
      </div>
```      