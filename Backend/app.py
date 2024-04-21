from flask import Flask, request, jsonify
from openai import OpenAI

client = OpenAI(api_key="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")
app = Flask(__name__)

@app.route('/Calculate', methods=['GET'])
def calulate():
    query = request.args.get('Query')
    days = request.args.get('Days')  # Retrieve the 'Days' parameter
    weeks = request.args.get('Weeks')  # Retrieve the 'Weeks' parameter
    months = request.args.get('Months')  # Retrieve the 'Months' parameter
    interval = request.args.get('Interval')  # Retrieve the 'Interval' parameter
    special_instructions = "Special Instructions: " + request.args.get('SpecialInstructions')

    duration_parts = []
    if days:
        duration_parts.append(f"{days} day{'s' if int(days) > 1 else ''}")
    if weeks:
        duration_parts.append(f"{weeks} week{'s' if int(weeks) > 1 else ''}")
    if months:
        duration_parts.append(f"{months} month{'s' if int(months) > 1 else ''}")

    duration = " ".join(duration_parts)

    # Adjust the prompt to include the interval and duration parameters
    prompt = f"Give me a roadmap to learn {query} in {duration}. Format the roadmap in a Day by Day format such that every Day has all the learning concepts in a checklist bullet format, attached with YouTube video links and paid courses links for that particular Day. {special_instructions}"

    response = client.completions.create(
        model="gpt-3.5-turbo-instruct",
        prompt=prompt,
        max_tokens=4000
    )

    res = jsonify(response.choices[0].text)
    return res

if __name__ == '__main__':
    app.run()
