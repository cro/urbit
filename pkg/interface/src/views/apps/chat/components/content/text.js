import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import ReactMarkdown from 'react-markdown';
import RemarkDisableTokenizers from 'remark-disable-tokenizers';
import RemarkBreaks from 'remark-breaks';
import urbitOb from 'urbit-ob';
import { Text } from '@tlon/indigo-react';

const DISABLED_BLOCK_TOKENS = [
  'indentedCode',
  'atxHeading',
  'thematicBreak',
  'list',
  'setextHeading',
  'html',
  'definition',
  'table'
];

const DISABLED_INLINE_TOKENS = [
  'autoLink',
  'url',
  'email',
  'link',
  'reference'
];

const renderers = {
  inlineCode: ({language, value}) => {
    return <Text mono p='1' backgroundColor='washedGray' fontSize='0' style={{ whiteSpace: 'preWrap'}}>{value}</Text>
  },
  paragraph: ({ children }) => {
    return (<Text fontSize="1">{children}</Text>);
  },
  code: ({language, value}) => {
    return <Text
              p='1'
              className='clamp-message'
              display='block'
              borderRadius='1'
              mono
              fontSize='0'
              backgroundColor='washedGray'
              overflowX='auto'
              style={{ whiteSpace: 'pre'}}>
              {value}
            </Text>
  }
};

const MessageMarkdown = React.memo(props => (
  <ReactMarkdown
    {...props}
    unwrapDisallowed={true}
    renderers={renderers}
    // shim until we uncover why RemarkBreaks and
    // RemarkDisableTokenizers can't be loaded simultaneously
    disallowedTypes={['heading', 'list', 'listItem', 'link']}
    allowNode={(node, index, parent) => {
      if (
        node.type === 'blockquote'
        && parent.type === 'root'
        && node.children.length
        && node.children[0].type === 'paragraph'
        && node.children[0].position.start.offset < 2
      ) {
        node.children[0].children[0].value = '>' + node.children[0].children[0].value;
        return false;
      }

      return true;
    }}
    plugins={[RemarkBreaks]} />
));


export default class TextContent extends Component {

  render() {
    const { props } = this;
    const content = props.content;

    const group = content.text.match(
      /([~][/])?(~[a-z]{3,6})(-[a-z]{6})?([/])(([a-z0-9-])+([/-])?)+/
    );
    if ((group !== null) // matched possible chatroom
      && (group[2].length > 2) // possible ship?
      && (urbitOb.isValidPatp(group[2]) // valid patp?
      && (group[0] === content.text))) { // entire message is room name?
      return (
        <Text mx="2px" flexShrink={0} fontSize={props.fontSize ? props.fontSize : '14px'} color='black' lineHeight="tall">
          <Link
            className="bb b--black b--white-d mono"
            to={'/~landscape/join/' + group.input}>
            {content.text}
          </Link>
        </Text>
      );
    } else {
      return (
        <Text mx="2px" flexShrink={0} color='black' fontSize={props.fontSize ? props.fontSize : '14px'} lineHeight="tall" style={{ overflowWrap: 'break-word' }}>
          <MessageMarkdown source={content.text} />
        </Text>
      );
    }
  }
}
