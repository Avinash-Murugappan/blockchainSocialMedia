pragma solidity ^0.5.0;

contract Decentragram {
    string public name = "Decentragram";

    // Store images
    uint256 public imageCount = 0;
    mapping(uint256 => Image) public images;

    struct Image {
        uint256 id;
        string hash;
        string description;
        uint256 tipAmount;
        address payable author;
    }

    event ImageCreated(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );

    event ImageTipped(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );

    // Create images
    function uploadImage(string memory _imageHash, string memory _description)
        public
    {
        // Make sure image hash exists
        require(bytes(_imageHash).length > 0);

        // Make sure image description exists
        require(bytes(_description).length > 0);

        // Make sure uploader address exists
        require(msg.sender != address(0x0));

        // Incement image id
        imageCount++;

        // Add image to contract
        images[imageCount] = Image(
            imageCount,
            _imageHash,
            _description,
            0,
            msg.sender
        );

        // Trigger an event

        emit ImageCreated(imageCount, _imageHash, _description, 0, msg.sender);
    }

    //Tip images
    function tipImageOwner(uint256 _id) public payable {
        // Make sure the id is valid
        require(_id > 0 && _id <= imageCount);
        // fetch the image
        Image memory _image = images[_id];
        //fetch the author
        address payable _author = _image.author;
        // Pay the authro by sending them Ether
        address(_author).transfer(msg.value);
        // increment the tip amount
        _image.tipAmount = _image.tipAmount + msg.value;
        // update the image
        images[_id] = _image;

        // Trigger an event
        emit ImageTipped(
            _id,
            _image.hash,
            _image.description,
            _image.tipAmount,
            _author
        );
    }
}
