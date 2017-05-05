require 'rails_helper'

RSpec.describe TableFilter do

  it 'normalises tables' do
    input = <<~HEREDOC
      # Example 1

      ALPHA | BRAVO
      -- | --
      Content for Alpha | Content for Bravo

      # Example 2

      ALPHA | BRAVO
      -- | --
      Content for Alpha | Content for Bravo

      # Example 3

      | ALPHA | BRAVO |
      | ----- | ----- |
      | Content for Alpha | Content for Bravo |

      # Example 4

      | ALPHA             | BRAVO             |
      | ----------------- | ----------------- |
      | Content for Alpha | Content for Bravo |

      # Example 5

      ALPHA             | BRAVO
      ----------------- | -----------------
      Content for Alpha | Content for Bravo

      # Example 6

      |ALPHA|BRAVO|
      |-----|-----|
      |Content for Alpha|Content for Bravo|

      # Example 7

      |ALPHA            |BRAVO            |
      |-----------------|-----------------|
      |Content for Alpha|Content for Bravo|

      # Example 8

      ALPHA            |BRAVO
      -----------------|-----
      Content for Alpha|Content for Bravo
    HEREDOC

    expect(TableFilter.new.call(input)).to eq(<<~HEREDOC
      # Example 1

      ALPHA | BRAVO
      -- | --
      Content for Alpha | Content for Bravo

      # Example 2

      ALPHA | BRAVO
      -- | --
      Content for Alpha | Content for Bravo

      # Example 3

      | ALPHA | BRAVO |
      -- | --
      | Content for Alpha | Content for Bravo |

      # Example 4

      | ALPHA             | BRAVO             |
      -- | --
      | Content for Alpha | Content for Bravo |

      # Example 5

      ALPHA             | BRAVO
      -- | --
      Content for Alpha | Content for Bravo

      # Example 6

      |ALPHA|BRAVO|
      -- | --
      |Content for Alpha|Content for Bravo|

      # Example 7

      |ALPHA            |BRAVO            |
      -- | --
      |Content for Alpha|Content for Bravo|

      # Example 8

      ALPHA            |BRAVO
      -- | --
      Content for Alpha|Content for Bravo
    HEREDOC
    )
  end
end
