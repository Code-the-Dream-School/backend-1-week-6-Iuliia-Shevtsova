require "sinatra"

enable :sessions

get "/" do    
    session[:secret] = rand(1..100)
    session[:guess_history] = []
    erb :chances
end

post "/" do
    params.inspect
    @guess = params["guess"].to_i
    session[:guess_history] <<  @guess
    while session[:guess_history].length()<7 do

        if  session[:secret] != @guess
            if  (session[:secret] - @guess) > 10 
                @close_guess = "Your guess is much too low"
                @color = 'background: #FAEBD7'
                break
            elsif (session[:secret] - @guess) <= 10 && (session[:secret] - @guess) > 0
                @close_guess = "Your guess is close but too low"
                @color = 'background: #7FFFD4'
                break
            elsif (@guess - session[:secret]) <= 10 && (@guess - session[:secret]) > 0
                @close_guess = "Your guess is close but too high"
                @color = 'background: #FFA07A'
                break
            elsif(@guess - session[:secret]) > 10 
                @close_guess = "Your guess is way too high"
                @color = 'background: #90EE90'
                break
            end
        elsif session[:secret] == @guess
            @close_guess = "You win!!"
            break   
        end    
    end
    if session[:secret] == @guess
        erb :results
    elsif session[:guess_history].length() == 7
        @close_guess = "You lose..."
        erb :results
    else
        erb :chances
    end
end
    
