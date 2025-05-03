from flask import Flask, render_template, request, redirect, flash

app = Flask(__name__)
app.secret_key = 'your_secret_key'  # Needed for flash messages

# Home route
@app.route('/')
def home():
    return render_template('index.html')

# Projects overview page
@app.route('/projects')
def projects():
    return render_template('projects.html')

# Contact page
@app.route('/contact', methods=['GET', 'POST'])
def contact():
    if request.method == 'POST':
        name = request.form.get('name')
        email = request.form.get('email')
        message = request.form.get('message')

        # Save contact message to a file (you can customize this logic)
        with open('/home/ubuntu/Flask_clgg_app/messages.txt', 'a') as f:
            f.write(f"Name: {name}, Email: {email}, Message: {message}\n")

        flash("Your message has been sent!", "success")
        return redirect('/contact')

    return render_template('contact.html')

# === Individual project detail pages ===

@app.route('/talkdoc')
def talkdoc():
    return render_template('talkdoc.html')

@app.route('/encryptor')
def encryptor():
    return render_template('encryptor.html')

@app.route('/malware')
def malware():
    return render_template('malware.html')

# Run the Flask app on EC2 public IP, port 80
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)


