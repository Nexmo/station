import React from 'react'
import chunk from 'lodash/chunk'

class Concatenation extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      body: 'Maecenas sed diam eget risus varius blandit sit amet non magna. Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Curabitur blandit tempus porttitor. Maecenas sed diam eget risus varius blandit sit amet non magna. Cras mattis consectetur purus sit amet fermentum. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.'
    }
  }

  stringToBuffer(string, encoding) {
    return new Buffer(string, encoding)
  }

  splitStringByCodePoint(string) {
    return [...this.state.body]
  }

  split() {
    const length = this.state.body.length
    const stringArray = this.splitStringByCodePoint()
    let capacity = {}

    if (this.encodeAs16Bit()) {
      capacity = {
        partOne: 70,
        partTwo: 62,
        partThree: 66,
      }
    } else {
      capacity = {
        partOne: 160,
        partTwo: 146,
        partThree: 153,
      }
    }

    var a = [stringArray.slice(0, capacity.partOne).join('')]

    if (stringArray.length > capacity.partOne) {

      console.log(a);

      console.log(stringArray.slice(capacity.partOne, (capacity.partOne + capacity.partTwo)).join(''));

      a.push(stringArray.slice(capacity.partOne, (capacity.partOne + capacity.partTwo)).join(''))

      console.log(a);
    }

    if (stringArray.length > (capacity.partOne + capacity.partTwo)) {
      const remainder = stringArray.slice((capacity.partOne + capacity.partTwo))
      const arrays = chunk(remainder, capacity.partThree).map((a) => a.join(''))
      a = a.concat(arrays)
    }

    return a
  }

  encodeAs16Bit() {
    const encodedString = this.stringToBuffer(this.state.body, 'latin1')
    const decodedString = new TextDecoder('utf8').decode(encodedString)

    return (decodedString !== this.state.body)
  }

  renderSplit(split) {
    return split.map((group, index) => {
      return (
        <tr>
          <td style={{ 'vertical-align': 'middle' }}><b>Part {index + 1}</b></td>
          <td style={{ width: '75%' }}>
            <code
              style={{ 'white-space': 'normal' }}
            >{group}</code>
          </td>
        </tr>
      )
    })
  }

  bytes() {
    if (this.encodeAs16Bit()) {
      return this.stringToBuffer(this.state.body, 'utf8').byteLength
    } else {
      return this.stringToBuffer(this.state.body, 'latin1').byteLength
    }
  }

  renderUtfIcon(bool) {
    if (bool) {
      return (
        <i className="icon icon--large icon-check-circle color--success"/>
      )
    } else {
      return (
        <i className="icon icon--large icon-times-circle color--error"/>
      )
    }
  }

  render() {
    const split = this.split()

    return (
      <div className="box">
        <h2>Try it out</h2>

        <h3>Message</h3>

        <textarea
          className="input"
          onChange={ (event) => this.setState({ body: event.target.value })}
          value={ this.state.body }
          style={{ width: '100%', height: '150px' }}
        ></textarea>

        <br/><br/>

        <h3>Data</h3>

        <table>
          <tbody>
            <tr>
              <td><b>UTF-8 is Required?</b></td>
              <td style={{ width: '75%' }}>{ this.renderUtfIcon(this.encodeAs16Bit()) }</td>
            </tr>
            <tr>
              <td><b>Length</b></td>
              <td style={{ width: '75%' }}>{ this.splitStringByCodePoint(this.state.body).length } characters over {split.length} { split.length == 1 ? 'part' : 'parts' }</td>
            </tr>
          </tbody>
        </table>

        <h3>Parts</h3>

        <table>
          <tbody>
            { this.renderSplit(split) }
          </tbody>
        </table>
      </div>
    )
  }
}

export default Concatenation
