const TextModel = require("./text.model");

class TextService {
    static async createText(userId, topic, journey, start_date, end_date, completed_tasks) {
        const createText = new TextModel({
            userId,
            topic,
            journey,
            start_date,
            end_date,
           completed_tasks// Empty array as the default value
        });
        return await createText.save();
    }

    static async getText(userId) {
        try {
            const textList = await TextModel.find({ userId });
            return textList;
        } catch (error) {
            console.error("Error getting text:", error);
            throw error;
        }
    }

    static async storeCompletedTasks(userId, topic, tasks) {
        try {
            await TextModel.findOneAndUpdate(
                { userId, topic },
                { completed_tasks: tasks }, // Set completed_tasks to the new tasks array
                { upsert: true } // Create a new document if not found
            );
        } catch (error) {
            console.error("Error storing completed tasks:", error);
            throw error;
        }
    }
    
}

module.exports = TextService;
