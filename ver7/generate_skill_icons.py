import json
from openai import OpenAI
from openai import image_gen

# Load ally data
with open('scripts/Data/ally_data_updated.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

client = OpenAI()

for char, info in data['allies'].items():
    for skill in info['skills']:
        prompt = f"64x64 pixel art icon for skill '{skill['name']}', conceptually representing: {skill['description']}"
        path = skill['icon_path'].replace('res://', '')
        skill_type_dir = os.path.dirname(path)
        if not os.path.exists(skill_type_dir):
            os.makedirs(skill_type_dir)
        # Generate 1 icon
        resp = client.images.generate(n=1, size="64x64", prompt=prompt)
        # Save the generated image
        img_data = resp.data[0].b64_json
        with open(path, 'wb') as img_file:
            img_file.write(base64.b64decode(img_data))
