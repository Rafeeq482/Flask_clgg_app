from flask import Flask, render_template, request, redirect, flash

app = Flask(__name__)
app.secret_key = 'your_secret_key'  # Needed for flash messages

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/projects')
def projects():
    return render_template('projects.html')

@app.route('/contact', methods=['GET', 'POST'])
def contact():
    if request.method == 'POST':
        name = request.form.get('name')
        email = request.form.get('email')
        message = request.form.get('message')

        # Here you can handle form data: save to file, send email, store in DB, etc.
        with open('/home/ubuntu/Flask_clgg_app/messages.txt', 'a') as f:
            f.write(f"Name: {name}, Email: {email}, Message: {message}\n")

        flash("Your message has been sent!", "success")
        return redirect('/contact')

    return render_template('contact.html')

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
