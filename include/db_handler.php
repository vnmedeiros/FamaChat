<?php

/**
 * Class to handle all db operations
 * This class will have CRUD methods for database tables
 *
 * @author Ravi Tamada
 * @link URL Tutorial link
 */
class DbHandler {

    private $conn;

    function __construct() {
        require_once dirname(__FILE__) . '/db_connect.php';
        // opening db connection
        $db = new DbConnect();
        $this->conn = $db->connect();
    }

    // creating new user if not existed
    public function createUser($name, $email) {
        $response = array();

        // First check if user already existed in db
        if (!$this->isUserExists($email)) {
            // insert query
            $stmt = $this->conn->prepare("INSERT INTO users(name, email) values(?, ?)");
            $stmt->bind_param("ss", $name, $email);

            $result = $stmt->execute();

            $stmt->close();

            // Check for successful insertion
            if ($result) {
                // User successfully inserted
                $response["error"] = false;
                $response["user"] = $this->getUserByEmail($email);
            } else {
                // Failed to create user
                $response["error"] = true;
                $response["message"] = "Oops! An error occurred while registereing";
            }
        } else {
            // User with same email already existed in the db
            $response["error"] = false;
            $response["user"] = $this->getUserByEmail($email);
        }

        return $response;
    }

    // updating user GCM registration ID
    public function updateGcmID($user_id, $gcm_registration_id) {
        $response = array();
        $stmt = $this->conn->prepare("UPDATE users SET gcm_registration_id = ? WHERE user_id = ?");
        $stmt->bind_param("si", $gcm_registration_id, $user_id);

        if ($stmt->execute()) {
            // User successfully updated
            $response["error"] = false;
            $response["message"] = 'GCM registration ID updated successfully';
        } else {
            // Failed to update user
            $response["error"] = true;
            $response["message"] = "Failed to update GCM registration ID";
            $stmt->error;
        }
        $stmt->close();

        return $response;
    }

    // fetching single user by id
    public function getUser($user_id) {
        $stmt = $this->conn->prepare("SELECT user_id, name, email, gcm_registration_id, created_at FROM users WHERE user_id = ?");
        $stmt->bind_param("s", $user_id);
        if ($stmt->execute()) {
            // $user = $stmt->get_result()->fetch_assoc();
            $stmt->bind_result($user_id, $name, $email, $gcm_registration_id, $created_at);
            $stmt->fetch();
            $user = array();
            $user["user_id"] = $user_id;
            $user["name"] = $name;
            $user["email"] = $email;
            $user["gcm_registration_id"] = $gcm_registration_id;
            $user["created_at"] = $created_at;
            $stmt->close();
            return $user;
        } else {
            return NULL;
        }
    }

    // fetching multiple users by ids
    public function getUsers($user_ids) {

        $users = array();
        if (sizeof($user_ids) > 0) {
            $query = "SELECT user_id, name, email, gcm_registration_id, created_at FROM users WHERE user_id IN (";

            foreach ($user_ids as $user_id) {
                $query .= $user_id . ',';
            }

            $query = substr($query, 0, strlen($query) - 1);
            $query .= ')';

            $stmt = $this->conn->prepare($query);
            $stmt->execute();
            $result = $stmt->get_result();

            while ($user = $result->fetch_assoc()) {
                $tmp = array();
                $tmp["user_id"] = $user['user_id'];
                $tmp["name"] = $user['name'];
                $tmp["email"] = $user['email'];
                $tmp["gcm_registration_id"] = $user['gcm_registration_id'];
                $tmp["created_at"] = $user['created_at'];
                array_push($users, $tmp);
            }
            
            $stmt->close();
        }

        return $users;
    }

    // messaging in a chat room / to personal message
    public function addMessage($user_id, $chat_room_id, $message) {
        $response = array();

        $stmt = $this->conn->prepare("INSERT INTO chat_room_messages (chat_room_id, user_id, message) values(?, ?, ?)");
        $stmt->bind_param("iis", $chat_room_id, $user_id, $message);

        if ($result = $stmt->execute()) {
            $response['error'] = false;

            // get the message
            $message_id = $this->conn->insert_id;
            $stmt = $this->conn->prepare("SELECT message_id, user_id, chat_room_id, message, created_at FROM chat_room_messages WHERE message_id = ?");
            $stmt->bind_param("i", $message_id);
            if ($stmt->execute()) {
                $stmt->bind_result($message_id, $user_id, $chat_room_id, $message, $created_at);
                $stmt->fetch();
                $tmp = array();
                $tmp['message_id'] = $message_id;
                $tmp['chat_room_id'] = $chat_room_id;
                $tmp['message'] = $message;
                $tmp['created_at'] = $created_at;
                $response['message'] = $tmp;
            }
        } else {
            $response['error'] = true;
            $response['message'] = 'Failed send message ' . $stmt->error;
        }

        return $response;
    }
    
    //Add user to chat
    public function addUserToChat($user_id_from, $user_email_to, $chat_room_id) {
        $response = array();
        
        if(!$this->isUserChatAdmin($user_id_from, $chat_room_id)){
            $response['error'] = true;
            $response['message'] = 'User is not a admin ';
            
            return $response;
        }
        
        $user_to = $this->getUserByEmail($user_email_to);
        
        $created_at = date('Y-m-d G:i:s');

        $stmt = $this->conn->prepare("INSERT INTO user_chat_room ( user_id, chat_room_id, created_at) values(?, ?, ?)");
        $stmt->bind_param("iis", $user_to["user_id"], $chat_room_id, $created_at);

        if ($result = $stmt->execute()) {
            $response = $this->addMessage($user_id_from, $chat_room_id, 'welcome '. $user_email_to  .'!');
        } else {
            $response['error'] = true;
            $response['message'] = 'Failed send message ' . $stmt->error;
        }

        return $response;
    }

    // fetching all chat rooms
    public function getAllChatrooms() {
        $stmt = $this->conn->prepare("SELECT * FROM chat_rooms");
        $stmt->execute();
        $tasks = $stmt->get_result();
        $stmt->close();
        return $tasks;
    }
    
    public function getAllUsers() {
        $stmt = $this->conn->prepare("SELECT * FROM users");
        $stmt->execute();
        $tasks = $stmt->get_result();
        $stmt->close();
        return $tasks;
    }
    
    public function getAdminUser() {
        $name = 'AndroidHive';
        $email = 'admin@androidhive.info';
        
        $stmt = $this->conn->prepare("SELECT user_id from users WHERE email = ?");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $stmt->store_result();
        $num_rows = $stmt->num_rows;
        if ($num_rows > 0) {
            $stmt->bind_result($user_id);
            $stmt->fetch();
            return $user_id;
        } else {
            $stmt = $this->conn->prepare("INSERT INTO users(name, email) values(?, ?)");
            $stmt->bind_param("ss", $name, $email);
            $result = $stmt->execute();
            $user_id = $stmt->insert_id;
            $stmt->close();
            return $user_id;
        }
    }

    // fetching single chat room by id
    function getChatRoom($chat_room_id) {
        $stmt = $this->conn->prepare("SELECT cr.chat_room_id, cr.name, cr.created_at as chat_room_created_at, u.name as username, c.* 
        FROM chat_rooms cr 
        LEFT JOIN chat_room_messages c ON c.chat_room_id = cr.chat_room_id 
        LEFT JOIN users u ON u.user_id = c.user_id 
        WHERE cr.chat_room_id = ?");
        $stmt->bind_param("i", $chat_room_id);
        $stmt->execute();
        $tasks = $stmt->get_result();
        $stmt->close();
        return $tasks;
    }
    
    // fetching Private Chats chat room by id
    //NEM PRECISAVA DO USER_TO_ID, MAS...
    function getPrivateChats($user_from_id) {
        $stmt = $this->conn->prepare("SELECT pm.user_to_id, ut.name as name_user_to, ut.created_at as created_at_user_to 
        FROM users u 
            INNER JOIN private_messages pm ON pm.user_to_id = u.user_id OR pm.user_from_id = u.user_id 
            INNER JOIN users ut ON ut.user_id = pm.user_to_id 
            INNER JOIN users uf ON uf.user_id = pm.user_from_id 
        WHERE u.user_id = ? and pm.is_active = 1");
        $stmt->bind_param("i", $user_from_id);
        $stmt->execute();
        $tasks = $stmt->get_result();
        $stmt->close();
        return $tasks;
    }
    
    //NEM PRECISAVA DO USER_TO_ID, MAS...
    function getPrivateChatsMenssages($user_from_id, $user_to_id) {
        $stmt = $this->conn->prepare("SELECT * FROM private_messages pm 
        WHERE pm.user_from_id = ?  and pm.user_to_id = ? and pm.is_active = 1");
        $stmt->bind_param("ii", $user_from_id, $user_to_id);
        $stmt->execute();
        $tasks = $stmt->get_result();
        $stmt->close();
        return $tasks;
    }
    
    // fetching single chat room by user_id
    function getChatRoomByUser($user_id) {
        $stmt = $this->conn->prepare("SELECT cr.*, ucr.is_admin 
        FROM chat_rooms cr 
        INNER JOIN user_chat_room ucr ON ucr.chat_room_id = cr.chat_room_id WHERE ucr.user_id = ?");
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $tasks = $stmt->get_result();
        $stmt->close();
        return $tasks;
    }

    /**
     * Checking for duplicate user by email address
     * @param String $email email to check in db
     * @return boolean
     */
    private function isUserExists($email) {
        $stmt = $this->conn->prepare("SELECT user_id from users WHERE email = ?");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $stmt->store_result();
        $num_rows = $stmt->num_rows;
        $stmt->close();
        return $num_rows > 0;
    }

    /**
     * Fetching user by email
     * @param String $email User email id
     */
    public function getUserByEmail($email) {
        $stmt = $this->conn->prepare("SELECT user_id, name, email, created_at FROM users WHERE email = ?");
        $stmt->bind_param("s", $email);
        if ($stmt->execute()) {
            // $user = $stmt->get_result()->fetch_assoc();
            $stmt->bind_result($user_id, $name, $email, $created_at);
            $stmt->fetch();
            $user = array();
            $user["user_id"] = $user_id;
            $user["name"] = $name;
            $user["email"] = $email;
            $user["created_at"] = $created_at;
            $stmt->close();
            return $user;
        } else {
            return NULL;
        }
    }
    
    private function isUserChatAdmin($user_id, $chat_room_id) {
        $stmt = $this->conn->prepare("SELECT ucr.user_id 
        FROM user_chat_room ucr 
        WHERE ucr.user_id = ? and ucr.chat_room_id = ? and ucr.is_admin = 1");
        $stmt->bind_param("ii", $user_id, $chat_room_id);
        $stmt->execute();
        $stmt->store_result();
        $num_rows = $stmt->num_rows;
        $stmt->close();
        
        return ($num_rows > 0);
    }

}

?>
