import axios from "axios";

export async function getTags() {
  try {

    // Gửi yêu cầu để lấy danh sách người dùng
    const response = await axios.get(
      "https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/tag/"
    );

    return response.data.map((tag) => ({
      id: tag.id,
      name: tag.name,
    }));
  } catch (error) {
    console.error("Error fetching tag:", error);
    return []; // Hoặc bạn có thể xử lý khác tùy ý
  }
}

export async function getTagById(tagID) {
  try {

    // Gửi yêu cầu để lấy danh sách người dùng
    const response = await axios.get(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/tag/${tagID}`
    );

    const tag = response.data;
    return {
      id: tag.id,
      name: tag.name,
    };
  } catch (error) {
    console.error("Error fetching tag:", error);
    return []; // Hoặc bạn có thể xử lý khác tùy ý
  }
}

export async function updateTag(tag) {
    try {
      const url = new URL(
        `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/tag/${tag.id}`
      );
  
      // Gửi PUT request với dữ liệu từ JSON
      const response = await axios.put(url.toString(), { name: tag.name }, {
        headers: {
          "Content-Type": "application/json",
        },
      });
  
      if (response.status === 200) {
        console.log("Tag updated successfully");
        return { success: true, message: "Tag updated successfully" };
      }
    } catch (error) {
      console.error("Error updating tag:", error);
      return { success: false, message: "Failed to update tag" };
    }
  }

  export async function addTag(tag) {
    try {
  
      const url = new URL(
        `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/tag/`
      );
  
      const response = await axios.post(url.toString(), {
        name: tag.name,
      }, {
        headers: {
          "Content-Type": "application/json",
        },
      });
  
      if (response.status === 201) {
        console.log("Tag added successfully");
        return { success: true, message: "Tag added successfully" };
      }
    } catch (error) {
      console.error("Error adding tag:", error);
      return { success: false, message: "Failed to add tag" };
    }
  }

export async function deleteTag(tagID) {
  try {

    const response = await axios.delete(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/tag/${tagID}`
    );

    if (response.status === 200) {
      console.log("Tag delete successfully");
      return { success: true, message: "Tag delete successfully" };
    }
  } catch (error) {
    console.error("Error deleting city:", error);
    return { success: false, message: "Failed to deleting city" };
  }
}

export async function addTagToDestination(tag_id, destination_id) {
    try {
      const url = new URL(
        `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/tag/add_to_destination`
      );
      url.searchParams.append('tag_id', tag_id);
      url.searchParams.append('dest_id', destination_id);
  
      const response = await axios.post(url.toString(), {}, {
        headers: {
          "accept": "application/json",
        },
      });
  
      if (response.status === 201) {
        console.log("Tag added to destination successfully");
        return { success: true, message: "Tag added successfully" };
      }
    } catch (error) {
      console.error("Error adding tag:", error);
      return { success: false, message: "Failed to add tag" };
    }
  }