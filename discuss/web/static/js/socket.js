import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

const addComment = (channel) => {
  return (content) => {
    channel.push("comments:add", {content});
  };
};

const createSocket = (topicId, renderComments) => {
  const channel = socket.channel(`comments:${topicId}`, {});
  channel.join()
    .receive("ok", resp => renderComments(resp.comments))
    .receive("error", resp => { console.log("Unable to join", resp) });

  return {
    channel,
    addComment: addComment(channel)
  };
};

window.createSocket = createSocket;
