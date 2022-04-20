---
title: Handling errors in Java
date: 2012-09-19
---
There are two ways to handle errors in Java; you can handle the error yourself,
or make someone else deal with it.  The general rule of thumb to follow seems
to be make someone else deal with it, unless you can't.

### Making someone else deal

Lets say we have a method that reads from a file.

{% highlight java %}
public String readFile(File file) {
    return new Scanner(file).useDelimiter("\\Z").next();
}
{% endhighlight %}

When trying to compile this piece of code we'll be told that we need the
handle the `FileNotFoundException`.  We go back to our rule of thumb and
realize that there is nothing stopping us from making someone else deal with the
error.

To make the compile error go away all we have to add is a throws declaration.

{% highlight java %}
public String readFile(File file) throws FileNotFoundException {
    return new Scanner(file).useDelimiter("\\Z").next();
}
{% endhighlight %}

### Dealing with it ourselves

Now lets say we're writing a Thread class.  If any error happens here we have
no one the pass the blame to.  We're at the top, and need to deal with the
errors coming at us or we're going to die as a thread.

This is where try-catch blocks come into play.  These catch errors and let us
deal with them.

{% highlight java %}
public void run() {
    try {
        String request = io.read();
        String response = serverResponse(request);
        io.write(response);
    } catch (IOException e) {
        System.err.println("Something went wrong reading/writing to IO");
        e.printStackTrace();
    } finally {
        try {
            io.close();
        } catch (IOException e) {
            System.err.println("Could not close the IO");
            e.printStackTrace();
        }
    }
}
{% endhighlight %}
