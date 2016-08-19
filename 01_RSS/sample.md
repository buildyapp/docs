---
title: サンプルフィード
date: 19 Aug 2016
---

以下はBuildy用のサンプルフィード。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <title>Daniel Perez blog</title>
    <description>blog about programming</description>
    <link>http://tuvistavie.com//</link>
    <language>en</language>
    <ttl>60</ttl>
    <pubDate>Thu, 30 Jun 2016 10:33:06 +0000</pubDate>

    <bdy:tab>
      <title>Top</title>
    </bdy:tab>
    <bdy:tab>
      <title>Projects</title>
      <filter operator="eq">
        <field>bdy:category</field>
        <value>Projects</field>
      </filter>
    </bdy:tab>
    <bdy:tab>
      <title>How To</title>
      <filter operator="eq">
        <field>bdy:category</field>
        <value>How To</field>
      </filter>
    </bdy:tab>

      <item>
        <title>Use Atom to edit in Chrome</title>

        <category>Projects</category>
        <category>Chrome</category>
        <category>Atom</category>

        <pubDate>Wed, 24 Feb 2016 00:00:00 +0000</pubDate>
        <link>http://tuvistavie.com/2016/atomic-chrome/</link>

        <bdy:category>Projects</bdy:category>
        <bdy:thumbnail>https://cloud.githubusercontent.com/assets/1436271/12668235/c228c514-c697-11e5-8cea-e71acabcd300.png</bdy:thumbnail>
        <bdy:image>https://cloud.githubusercontent.com/assets/1436271/12668226/afe32e26-c697-11e5-9814-2158e665f774.gif</bdy:thumbnail>

        <bdy:relatedLink
          title="Optional parameters and decorators in JavaScript"
          link="http://tuvistavie.com/2015/javascript-optional-parameters/"
          thumbnail="http://tuvistavie.com/images/profile.png" />
        <bdy:relatedLink
          title="Grunt errors in browser"
          link="http://tuvistavie.com/2014/grunt-errors-in-browser/"
          thumbnail="http://res.cloudinary.com/dtdu3sqtl/image/upload/c_scale,w_550/v1408153873/optimised_pozz3l.gif" />

        <description>I decided to create a plugin to simplify the process, which I
named &lt;a href=&quot;https://github.com/tuvistavie/atomic-chrome&quot;&gt;Atomic Chrome&lt;/a&gt;.
If you want to know why it is (or at least can be) useful, there &lt;a href=&quot;https://news.ycombinator.com/item?id=11022356&quot;&gt;a thread on Hackernews&lt;/a&gt; about it.&lt;/p&gt;</description>

        <content:encoded>&lt;p&gt;After &lt;a href=&quot;https://github.com/blog/2097-improved-commenting-with-markdown&quot;&gt;GitHub added plenty of shortcuts&lt;/a&gt; to edit
markdown in the browser, I had some problem editing directly, having all
the native Emacs like shortcuts overridden.&lt;/p&gt;

&lt;p&gt;I decided to use Atom to edit even more or less short comments, but
the copy-pasting was becoming a bit superfluous, taking more time
than it should.
I therefore decided to create a plugin to simplify the process, which I
named &lt;a href=&quot;https://github.com/tuvistavie/atomic-chrome&quot;&gt;Atomic Chrome&lt;/a&gt;.
If you want to know why it is (or at least can be) useful, there &lt;a href=&quot;https://news.ycombinator.com/item?id=11022356&quot;&gt;a thread on Hackernews&lt;/a&gt; about it.&lt;/p&gt;

&lt;p&gt;&lt;img src=&quot;https://cloud.githubusercontent.com/assets/1436271/12668226/afe32e26-c697-11e5-9814-2158e665f774.gif&quot; alt=&quot;Gmail editing&quot; /&gt;&lt;/p&gt;

&lt;p&gt;I will give a short explanation of how it works here.&lt;/p&gt;

&lt;p&gt;The system uses two plugins, a plugin for Google Chrome, and one for
Atom and communicates using WebSockets.
When the Atom plugin starts, it launches a WebSocket server and just waits.
On the Chrome side, when the plugin is launched, it connects to the WebSocket
server, and sends a message to register the current focused textarea.&lt;br /&gt;
The Atom plugin then opens a new tab to edit it, and the content of the textarea
and the Atom tab is synchronized using WS messages.&lt;/p&gt;

&lt;p&gt;The process itself is very simple and straightforward, but the implementation
is a little more tedious than it seems to be, mainly due to Chrome security
restrictions.
Basically there were two major issues when implementing this:&lt;/p&gt;

&lt;ol&gt;
  &lt;li&gt;The content script being executed in the context of the current page,
  if the connection is secured, a non secured WS connection will not work&lt;/li&gt;
  &lt;li&gt;The content script cannot access the page JS, which is ok for textarea
  and content editable, but which makes it impossible to work with JS based
  editor like ACE.&lt;/li&gt;
&lt;/ol&gt;

&lt;p&gt;To handle the secured WS issue, the obvious solution was to move the WebSocket
connection to a background script. This adds a layer of message passing, which
goes from&lt;/p&gt;

&lt;div class=&quot;highlighter-rouge&quot;&gt;&lt;pre class=&quot;highlight&quot;&gt;&lt;code&gt;Chrome content script -&amp;gt; Atom WS server
&lt;/code&gt;&lt;/pre&gt;
&lt;/div&gt;

&lt;p&gt;to&lt;/p&gt;

&lt;div class=&quot;highlighter-rouge&quot;&gt;&lt;pre class=&quot;highlight&quot;&gt;&lt;code&gt;Chrome content script -&amp;gt; Chrome background script -&amp;gt; Atom WS server
&lt;/code&gt;&lt;/pre&gt;
&lt;/div&gt;

&lt;p&gt;with the &lt;code class=&quot;highlighter-rouge&quot;&gt;content script -&amp;gt; background script&lt;/code&gt; message passing
done using the &lt;a href=&quot;https://developer.chrome.com/extensions/runtime#type-Port&quot;&gt;Chrome port&lt;/a&gt;.&lt;/p&gt;

&lt;p&gt;To be able to access the JS in the page, the solution was to inject a script
into the page that will have full access to it, and make it communicate with
the content script to get and set the value of ACE, or whatever JS editor
we need to handle.
Again, this adds another layer of message passing, so
the final flow becomes something like this:&lt;/p&gt;

&lt;div class=&quot;highlighter-rouge&quot;&gt;&lt;pre class=&quot;highlight&quot;&gt;&lt;code&gt;Injected script -&amp;gt; Chrome content script -&amp;gt; Chrome background script -&amp;gt; Atom WS server
&lt;/code&gt;&lt;/pre&gt;
&lt;/div&gt;

&lt;p&gt;with the &lt;code class=&quot;highlighter-rouge&quot;&gt;injected script -&amp;gt; content script&lt;/code&gt; message sent using &lt;code class=&quot;highlighter-rouge&quot;&gt;window.postMessage&lt;/code&gt;.&lt;/p&gt;

&lt;p&gt;After this, it’s only a matter of adding a handler to support X or Y text editor.
This is how the class to support &lt;a href=&quot;https://codemirror.net/&quot;&gt;CodeMirror&lt;/a&gt; looks like.&lt;/p&gt;

&lt;div class=&quot;language-javascript highlighter-rouge&quot;&gt;&lt;pre class=&quot;highlight&quot;&gt;&lt;code&gt;&lt;span class=&quot;kr&quot;&gt;class&lt;/span&gt; &lt;span class=&quot;nx&quot;&gt;InjectedCodeMirrorHandler&lt;/span&gt; &lt;span class=&quot;kr&quot;&gt;extends&lt;/span&gt; &lt;span class=&quot;nx&quot;&gt;BaseInjectedHandler&lt;/span&gt; &lt;span class=&quot;p&quot;&gt;{&lt;/span&gt;
  &lt;span class=&quot;nx&quot;&gt;load&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;()&lt;/span&gt; &lt;span class=&quot;p&quot;&gt;{&lt;/span&gt;
    &lt;span class=&quot;k&quot;&gt;this&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;editor&lt;/span&gt; &lt;span class=&quot;o&quot;&gt;=&lt;/span&gt; &lt;span class=&quot;k&quot;&gt;this&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;elem&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;parentElement&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;parentElement&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;CodeMirror&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;;&lt;/span&gt;
    &lt;span class=&quot;k&quot;&gt;return&lt;/span&gt; &lt;span class=&quot;nx&quot;&gt;Promise&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;resolve&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;();&lt;/span&gt;
  &lt;span class=&quot;p&quot;&gt;}&lt;/span&gt;

  &lt;span class=&quot;nx&quot;&gt;getValue&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;()&lt;/span&gt; &lt;span class=&quot;p&quot;&gt;{&lt;/span&gt;
    &lt;span class=&quot;k&quot;&gt;return&lt;/span&gt; &lt;span class=&quot;k&quot;&gt;this&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;editor&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;getValue&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;();&lt;/span&gt;
  &lt;span class=&quot;p&quot;&gt;}&lt;/span&gt;

  &lt;span class=&quot;nx&quot;&gt;setValue&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;(&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;text&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;)&lt;/span&gt; &lt;span class=&quot;p&quot;&gt;{&lt;/span&gt;
    &lt;span class=&quot;k&quot;&gt;this&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;executeSilenced&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;(()&lt;/span&gt; &lt;span class=&quot;o&quot;&gt;=&amp;gt;&lt;/span&gt; &lt;span class=&quot;k&quot;&gt;this&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;editor&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;setValue&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;(&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;text&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;));&lt;/span&gt;
  &lt;span class=&quot;p&quot;&gt;}&lt;/span&gt;

  &lt;span class=&quot;nx&quot;&gt;bindChange&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;(&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;f&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;)&lt;/span&gt; &lt;span class=&quot;p&quot;&gt;{&lt;/span&gt;
    &lt;span class=&quot;k&quot;&gt;this&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;editor&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;on&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;(&lt;/span&gt;&lt;span class=&quot;s1&quot;&gt;&#39;change&#39;&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;,&lt;/span&gt; &lt;span class=&quot;k&quot;&gt;this&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;wrapSilence&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;(&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;f&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;));&lt;/span&gt;
  &lt;span class=&quot;p&quot;&gt;}&lt;/span&gt;

  &lt;span class=&quot;nx&quot;&gt;unbindChange&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;(&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;f&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;)&lt;/span&gt; &lt;span class=&quot;p&quot;&gt;{&lt;/span&gt;
    &lt;span class=&quot;k&quot;&gt;this&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;editor&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;off&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;(&lt;/span&gt;&lt;span class=&quot;s1&quot;&gt;&#39;change&#39;&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;,&lt;/span&gt; &lt;span class=&quot;nx&quot;&gt;f&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;);&lt;/span&gt;
  &lt;span class=&quot;p&quot;&gt;}&lt;/span&gt;

  &lt;span class=&quot;nx&quot;&gt;getExtension&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;()&lt;/span&gt; &lt;span class=&quot;p&quot;&gt;{&lt;/span&gt;
    &lt;span class=&quot;kr&quot;&gt;const&lt;/span&gt; &lt;span class=&quot;nx&quot;&gt;currentModeName&lt;/span&gt; &lt;span class=&quot;o&quot;&gt;=&lt;/span&gt; &lt;span class=&quot;k&quot;&gt;this&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;editor&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;getMode&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;().&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;name&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;;&lt;/span&gt;
    &lt;span class=&quot;k&quot;&gt;if&lt;/span&gt; &lt;span class=&quot;p&quot;&gt;(&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;commonModes&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;[&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;currentModeName&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;])&lt;/span&gt; &lt;span class=&quot;p&quot;&gt;{&lt;/span&gt;
      &lt;span class=&quot;k&quot;&gt;return&lt;/span&gt; &lt;span class=&quot;nx&quot;&gt;commonModes&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;[&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;currentModeName&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;];&lt;/span&gt;
    &lt;span class=&quot;p&quot;&gt;}&lt;/span&gt;
    &lt;span class=&quot;k&quot;&gt;for&lt;/span&gt; &lt;span class=&quot;p&quot;&gt;(&lt;/span&gt;&lt;span class=&quot;kr&quot;&gt;const&lt;/span&gt; &lt;span class=&quot;nx&quot;&gt;mode&lt;/span&gt; &lt;span class=&quot;nx&quot;&gt;of&lt;/span&gt; &lt;span class=&quot;nx&quot;&gt;CodeMirror&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;modeInfo&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;)&lt;/span&gt; &lt;span class=&quot;p&quot;&gt;{&lt;/span&gt;
      &lt;span class=&quot;k&quot;&gt;if&lt;/span&gt; &lt;span class=&quot;p&quot;&gt;(&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;mode&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;mode&lt;/span&gt; &lt;span class=&quot;o&quot;&gt;===&lt;/span&gt; &lt;span class=&quot;nx&quot;&gt;currentModeName&lt;/span&gt; &lt;span class=&quot;o&quot;&gt;&amp;amp;&amp;amp;&lt;/span&gt; &lt;span class=&quot;nx&quot;&gt;mode&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;ext&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;)&lt;/span&gt; &lt;span class=&quot;p&quot;&gt;{&lt;/span&gt;
        &lt;span class=&quot;k&quot;&gt;return&lt;/span&gt; &lt;span class=&quot;nx&quot;&gt;mode&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;nx&quot;&gt;ext&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;[&lt;/span&gt;&lt;span class=&quot;mi&quot;&gt;0&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;];&lt;/span&gt;
      &lt;span class=&quot;p&quot;&gt;}&lt;/span&gt;
    &lt;span class=&quot;p&quot;&gt;}&lt;/span&gt;
    &lt;span class=&quot;k&quot;&gt;return&lt;/span&gt; &lt;span class=&quot;kc&quot;&gt;null&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;;&lt;/span&gt;
  &lt;span class=&quot;p&quot;&gt;}&lt;/span&gt;
&lt;span class=&quot;p&quot;&gt;}&lt;/span&gt;
&lt;/code&gt;&lt;/pre&gt;
&lt;/div&gt;

&lt;p&gt;so it would be quite simple to add support for some other editor as well.&lt;/p&gt;

&lt;p&gt;I am now planning on adding the possibility to live convert markdown to HTML,
which would give a nice way to write email in markdown and have a live preview
with the email exactly as it will be sent.&lt;/p&gt;
</content:encoded>


      </item>

      <item>
        <title>Run commands only on git update with Ansible</title>

        <category>How To</category>
        <category>DevOps</category>
        <category>Ansible</category>

        <pubDate>Sat, 12 Sep 2015 00:00:00 +0000</pubDate>
        <link>http://tuvistavie.com/2015/ansible-git-update/</link>

        <bdy:category>How To</bdy:category>
        <bdy:thumbnail>https://www.skytap.com/wp-content/uploads/2015/12/SetWidth360-ansible-logo-black-square.png</bdy:thumbnail>

        <bdy:relatedLink
          title="SSH invalid byte sequence"
          link="http://tuvistavie.com/2015/chef-ssh-invalid-sequence/"
          thumbnail="http://tuvistavie.com/images/profile.png" />

        <description>I wanted to run some commands only when the git repository had been updated, and  do nothing if it was already up to date.</description>
        <content:encoded>&lt;p&gt;I have recently switched my automation workflow from Chef to Ansible, and just bumped into a simple issue.&lt;/p&gt;

&lt;p&gt;I wanted to run some commands only when the git repository had been updated, and  do nothing if it was already up to date.&lt;/p&gt;

&lt;p&gt;I did not find anything &lt;a href=&quot;http://docs.ansible.com/ansible/git_module.html&quot;&gt;in the documentation&lt;/a&gt;, but after looking a little at the source code, I found out that when using &lt;code class=&quot;highlighter-rouge&quot;&gt;register&lt;/code&gt;, &lt;code class=&quot;highlighter-rouge&quot;&gt;myvar.changed&lt;/code&gt; was set to &lt;code class=&quot;highlighter-rouge&quot;&gt;true&lt;/code&gt; or &lt;code class=&quot;highlighter-rouge&quot;&gt;false&lt;/code&gt; depending on whether the repository had been updated or not.&lt;/p&gt;

&lt;p&gt;So, to get the result I wanted, I just had to write something like this:&lt;/p&gt;

&lt;div class=&quot;language-yaml highlighter-rouge&quot;&gt;&lt;pre class=&quot;highlight&quot;&gt;&lt;code&gt;&lt;span class=&quot;pi&quot;&gt;-&lt;/span&gt; &lt;span class=&quot;s&quot;&gt;name&lt;/span&gt;&lt;span class=&quot;pi&quot;&gt;:&lt;/span&gt; &lt;span class=&quot;s&quot;&gt;Fetch project&lt;/span&gt;
  &lt;span class=&quot;s&quot;&gt;git&lt;/span&gt;&lt;span class=&quot;pi&quot;&gt;:&lt;/span&gt; &lt;span class=&quot;s&quot;&gt;repo= accept_hostkey=yes dest=&lt;/span&gt;
  &lt;span class=&quot;s&quot;&gt;register&lt;/span&gt;&lt;span class=&quot;pi&quot;&gt;:&lt;/span&gt; &lt;span class=&quot;s&quot;&gt;gitclone&lt;/span&gt;

&lt;span class=&quot;pi&quot;&gt;-&lt;/span&gt; &lt;span class=&quot;s&quot;&gt;name&lt;/span&gt;&lt;span class=&quot;pi&quot;&gt;:&lt;/span&gt; &lt;span class=&quot;s&quot;&gt;Build project&lt;/span&gt;
  &lt;span class=&quot;s&quot;&gt;command&lt;/span&gt;&lt;span class=&quot;pi&quot;&gt;:&lt;/span&gt; &lt;span class=&quot;s&quot;&gt;make&lt;/span&gt;
  &lt;span class=&quot;s&quot;&gt;when&lt;/span&gt;&lt;span class=&quot;pi&quot;&gt;:&lt;/span&gt; &lt;span class=&quot;s&quot;&gt;gitclone.changed&lt;/span&gt;
  &lt;span class=&quot;s&quot;&gt;args&lt;/span&gt;&lt;span class=&quot;pi&quot;&gt;:&lt;/span&gt;
    &lt;span class=&quot;s&quot;&gt;chdir&lt;/span&gt;&lt;span class=&quot;pi&quot;&gt;:&lt;/span&gt; &lt;span class=&quot;s2&quot;&gt;&quot;&lt;/span&gt;&lt;span class=&quot;s&quot;&gt;&quot;&lt;/span&gt;
&lt;/code&gt;&lt;/pre&gt;
&lt;/div&gt;

&lt;p&gt;I did not found a lot in the documentation about what can be used with &lt;code class=&quot;highlighter-rouge&quot;&gt;register&lt;/code&gt;, but I found out that it was easy enough to get this info from the source code, as it is a simple as looking for &lt;code class=&quot;highlighter-rouge&quot;&gt;module.exit_json&lt;/code&gt; calls in the module. For example for the &lt;a href=&quot;https://github.com/ansible/ansible-modules-core/blob/devel/files/copy.py#L320&quot;&gt;git module&lt;/a&gt;.&lt;/p&gt;
</content:encoded>


      </item>

      <item>
        <title>Persistent history in Elixir repl IEx</title>

        <category>How To</category>
        <category>Elixir</category>

        <pubDate>Wed, 02 Sep 2015 00:00:00 +0000</pubDate>
        <link>http://tuvistavie.com/2015/iex-persistent-history/</link>

        <bdy:category>How To</bdy:category>
        <bdy:thumbnail>https://avatars2.githubusercontent.com/u/1481354?v=3&s=400</bdy:thumbnail>
        <bdy:image>http://elixir-lang.org/images/logo/logo.png</bdy:image>

        <bdy:relatedLink
          title="What's coming in Elixir 1.3"
          link="http://tuvistavie.com/2016/elixir-1-3/"
          thumbnail="https://avatars2.githubusercontent.com/u/1481354?v=3&s=400" />

        <description>Elixir repl, IEx, history does not persist between sessions</description>
        <content:encoded>&lt;p&gt;Recently I am starting to use Elixir a bit more seriously, and a small issue I had was that Elixir repl, IEx, history does not persist between sessions.
Being used to repl like &lt;code class=&quot;highlighter-rouge&quot;&gt;ipython&lt;/code&gt; or &lt;code class=&quot;highlighter-rouge&quot;&gt;pry&lt;/code&gt; which do that out of the box, I wanted to have this functionality, which is in my opinion very convenient.&lt;/p&gt;

&lt;p&gt;It seems that the problem is more directly related to Erlang than to Elixir itself, and therefore, the workarounds that are used to get persistent history for the Erlang repl can also be used for Elixir.&lt;/p&gt;

&lt;p&gt;The &lt;a href=&quot;https://github.com/ferd/erlang-history&quot;&gt;erlang-history&lt;/a&gt; project worked perfectly for me&lt;/p&gt;

&lt;div class=&quot;language-sh highlighter-rouge&quot;&gt;&lt;pre class=&quot;highlight&quot;&gt;&lt;code&gt;git clone https://github.com/ferd/erlang-history.git
&lt;span class=&quot;nb&quot;&gt;cd &lt;/span&gt;erlang-history
make install
&lt;/code&gt;&lt;/pre&gt;
&lt;/div&gt;

&lt;p&gt;and I was able to get a history persistent across sessions. Note that &lt;code class=&quot;highlighter-rouge&quot;&gt;make install&lt;/code&gt; needs sudo if you do not have write permissions in the Erlang install directory.&lt;/p&gt;
</content:encoded>

      </item>

      <item>
        <title>Go serialization</title>

        <category>Projects</category>
        <category>Go</category>

        <pubDate>Fri, 29 May 2015 00:00:00 +0000</pubDate>
        <link>http://tuvistavie.com/2015/go-serialization/</link>

        <bdy:category>Projects</bdy:category>
        <bdy:thumbnail>http://www.unixstickers.com/image/cache/data/stickers/golang/golang.sh-600x600.png</bdy:thumbnail>

        <description>&lt;p&gt;I have been using Golang to build some REST API recently, and I was having some trouble to serialize my data properly to JSON.&lt;/p&gt;</description>

        <content:encoded>&lt;p&gt;I have been using Golang to build some REST API recently, and I was having some trouble to serialize my data properly to JSON.&lt;/p&gt;

&lt;p&gt;Almost all tutorial around there tell about how we should return JSON, using some &lt;code class=&quot;highlighter-rouge&quot;&gt;struct&lt;/code&gt; and tags.&lt;/p&gt;

&lt;div class=&quot;language-go highlighter-rouge&quot;&gt;&lt;pre class=&quot;highlight&quot;&gt;&lt;code&gt;&lt;span class=&quot;k&quot;&gt;type&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;User&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;k&quot;&gt;struct&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;p&quot;&gt;{&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;
    &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;ID&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;        &lt;/span&gt;&lt;span class=&quot;kt&quot;&gt;int&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;s&quot;&gt;`json:&quot;id&quot;`&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;
    &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;Email&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;     &lt;/span&gt;&lt;span class=&quot;kt&quot;&gt;string&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;s&quot;&gt;`json:&quot;email&quot;`&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;
    &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;HideEmail&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;kt&quot;&gt;bool&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;s&quot;&gt;`json:&quot;hide_email&quot;`&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;
    &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;FirstName&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;kt&quot;&gt;string&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;s&quot;&gt;`json:&quot;first_name&quot;`&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;
    &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;LastName&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;  &lt;/span&gt;&lt;span class=&quot;kt&quot;&gt;string&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;s&quot;&gt;`json:&quot;last_name&quot;`&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;
    &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;CreatedAt&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;time&lt;/span&gt;&lt;span class=&quot;o&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;n&quot;&gt;Time&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;s&quot;&gt;`json:&quot;created_at&quot;`&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;
    &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;UpdatedAt&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;time&lt;/span&gt;&lt;span class=&quot;o&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;n&quot;&gt;Time&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;s&quot;&gt;`json:&quot;updated_at&quot;`&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;
&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;}&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;

&lt;/span&gt;&lt;span class=&quot;n&quot;&gt;user&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;o&quot;&gt;:=&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;User&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;{&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;
    &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;ID&lt;/span&gt;&lt;span class=&quot;o&quot;&gt;:&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;m&quot;&gt;1&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;,&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;Email&lt;/span&gt;&lt;span class=&quot;o&quot;&gt;:&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;s&quot;&gt;&quot;x@example.com&quot;&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;,&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;FirstName&lt;/span&gt;&lt;span class=&quot;o&quot;&gt;:&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;s&quot;&gt;&quot;Foo&quot;&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;,&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;LastName&lt;/span&gt;&lt;span class=&quot;o&quot;&gt;:&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;  &lt;/span&gt;&lt;span class=&quot;s&quot;&gt;&quot;Bar&quot;&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;,&lt;/span&gt;&lt;span class=&quot;n&quot;&gt;HideEmail&lt;/span&gt;&lt;span class=&quot;o&quot;&gt;:&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;no&quot;&gt;true&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;
&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;}&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;

&lt;/span&gt;&lt;span class=&quot;n&quot;&gt;data&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;,&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;err&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;o&quot;&gt;:=&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;json&lt;/span&gt;&lt;span class=&quot;o&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;n&quot;&gt;Marshal&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;(&lt;/span&gt;&lt;span class=&quot;n&quot;&gt;user&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;)&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;
&lt;/span&gt;&lt;/code&gt;&lt;/pre&gt;
&lt;/div&gt;

&lt;p&gt;This is indeed useful, but there are many cases when we want to dynamically choose what to serialize depending some privacy settings, whether the user is logged in or not, or a lot of other factors.&lt;/p&gt;

&lt;p&gt;For these situations, I found it a bit verbose and repetitive to have to enter each field in a &lt;code class=&quot;highlighter-rouge&quot;&gt;map&lt;/code&gt; to be able to have the wanted serialization output, so I decided to create a little library to help me do this. Its goal is basically to help converting a &lt;code class=&quot;highlighter-rouge&quot;&gt;struct&lt;/code&gt; to a &lt;code class=&quot;highlighter-rouge&quot;&gt;map&lt;/code&gt; with the most flexibility as possible.&lt;/p&gt;

&lt;p&gt;With the above &lt;code class=&quot;highlighter-rouge&quot;&gt;struct&lt;/code&gt;, given I want to hide the &lt;code class=&quot;highlighter-rouge&quot;&gt;Email&lt;/code&gt; field when &lt;code class=&quot;highlighter-rouge&quot;&gt;HideEmail&lt;/code&gt; is true, I can write:&lt;/p&gt;

&lt;div class=&quot;language-go highlighter-rouge&quot;&gt;&lt;pre class=&quot;highlight&quot;&gt;&lt;code&gt;&lt;span class=&quot;n&quot;&gt;userSerializer&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;o&quot;&gt;:=&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;structomap&lt;/span&gt;&lt;span class=&quot;o&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;n&quot;&gt;New&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;()&lt;/span&gt;&lt;span class=&quot;o&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;
                             &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;UseSnakeCase&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;()&lt;/span&gt;&lt;span class=&quot;o&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;
                             &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;Pick&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;(&lt;/span&gt;&lt;span class=&quot;s&quot;&gt;&quot;ID&quot;&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;,&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;s&quot;&gt;&quot;Email&quot;&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;,&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;s&quot;&gt;&quot;FirstName&quot;&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;,&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;s&quot;&gt;&quot;LastName&quot;&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;)&lt;/span&gt;&lt;span class=&quot;o&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;
                             &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;Omit&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;(&lt;/span&gt;&lt;span class=&quot;s&quot;&gt;&quot;HideEmail&quot;&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;)&lt;/span&gt;&lt;span class=&quot;o&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;
                             &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;OmitIf&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;(&lt;/span&gt;&lt;span class=&quot;k&quot;&gt;func&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;(&lt;/span&gt;&lt;span class=&quot;n&quot;&gt;u&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;k&quot;&gt;interface&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;{})&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;kt&quot;&gt;bool&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;p&quot;&gt;{&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;
                                &lt;/span&gt;&lt;span class=&quot;k&quot;&gt;return&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;n&quot;&gt;u&lt;/span&gt;&lt;span class=&quot;o&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;(&lt;/span&gt;&lt;span class=&quot;n&quot;&gt;User&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;)&lt;/span&gt;&lt;span class=&quot;o&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;n&quot;&gt;HideEmail&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;
                            &lt;/span&gt;&lt;span class=&quot;p&quot;&gt;},&lt;/span&gt;&lt;span class=&quot;x&quot;&gt; &lt;/span&gt;&lt;span class=&quot;s&quot;&gt;&quot;Email&quot;&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;)&lt;/span&gt;&lt;span class=&quot;x&quot;&gt;
&lt;/span&gt;&lt;/code&gt;&lt;/pre&gt;
&lt;/div&gt;

&lt;p&gt;and then I just need to call &lt;code class=&quot;highlighter-rouge&quot;&gt;userSerializer.Transform&lt;/code&gt; on any user to get the result I want as a &lt;code class=&quot;highlighter-rouge&quot;&gt;map[string]interface{}&lt;/code&gt;. What is nice about this is that it also works with arrays: &lt;code class=&quot;highlighter-rouge&quot;&gt;userSerializer.TransformArray&lt;/code&gt; will transform an array of &lt;code class=&quot;highlighter-rouge&quot;&gt;User&lt;/code&gt; in an array of &lt;code class=&quot;highlighter-rouge&quot;&gt;map[string]interface{}&lt;/code&gt; which can be directly serialized to JSON.&lt;/p&gt;

&lt;p&gt;You can find more information on &lt;a href=&quot;https://github.com/tuvistavie/structomap&quot;&gt;the project page&lt;/a&gt;.&lt;/p&gt;
</content:encoded>

      </item>
  </channel>
</rss>
```